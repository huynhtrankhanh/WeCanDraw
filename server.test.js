const WebSocket = require('ws');
const request = require('supertest');
const crypto = require('crypto');
const { app, server, wss, db } = require('./server'); // Adjust path as needed

// Helper function to hash pool ID - same as server implementation
function hashPoolId(id) {
    return crypto.createHash('sha256').update(id).digest('hex');
}

describe('WebSocket Server Tests', () => {
  let clientSocket;
  const TEST_PORT = 3000;
  const TEST_POOL_ID = 'test-pool';
  const HASHED_POOL_ID = hashPoolId(TEST_POOL_ID);
  
  beforeAll((done) => {
    server.listen(TEST_PORT, () => {
      done();
    });
  });

  afterAll((done) => {
    server.close(() => {
      db.close(() => {
        done();
      });
    });
  });

  beforeEach(() => {
    // Clear database before each test
    return new Promise((resolve, reject) => {
      db.run('DELETE FROM events', (err) => {
        if (err) reject(err);
        resolve();
      });
    });
  });

  afterEach(() => {
    if (clientSocket && clientSocket.readyState === WebSocket.OPEN) {
      clientSocket.close();
    }
  });

  // Helper function to create a WebSocket connection
  const createWebSocketConnection = () => {
    return new Promise((resolve) => {
      const ws = new WebSocket(`ws://localhost:${TEST_PORT}/${TEST_POOL_ID}`);
      ws.on('open', () => resolve(ws));
    });
  };

  // Helper function to wait for a message
  const waitForMessage = (socket) => {
    return new Promise((resolve) => {
      socket.once('message', (data) => {
        resolve(data);
      });
    });
  };

  test('should establish WebSocket connection', async () => {
    clientSocket = await createWebSocketConnection();
    expect(clientSocket.readyState).toBe(WebSocket.OPEN);
  });

  test('should broadcast messages to other clients in the same pool', async () => {
    // Create two clients
    const client1 = await createWebSocketConnection();
    const client2 = await createWebSocketConnection();

    // Setup message receiving promise before sending
    const messagePromise = waitForMessage(client2);

    // Send message from client1
    const testPayload = Buffer.from('test message');
    client1.send(testPayload);

    // Wait for client2 to receive the message
    const receivedMessage = await messagePromise;
    
    // Parse the received binary message
    const lengthBuffer = receivedMessage.slice(0, 4);
    const idBuffer = receivedMessage.slice(4, 8);
    const payload = receivedMessage.slice(8);

    expect(payload.toString()).toBe(testPayload.toString());
    expect(lengthBuffer.readUInt32LE(0)).toBe(testPayload.length);
    expect(idBuffer.readUInt32LE(0)).toBe(1); // First message should have ID 1

    client1.close();
    client2.close();
  });

  test('should store messages in database', (done) => {
    createWebSocketConnection().then(client => {
      const testPayload = Buffer.from('test message');
      client.send(testPayload);

      // Give some time for database operation to complete
      setTimeout(() => {
        db.get('SELECT * FROM events WHERE pool_id = ?', [HASHED_POOL_ID], (err, row) => {
          expect(err).toBeNull();
          expect(row).toBeTruthy();
          expect(Buffer.from(row.payload).toString()).toBe(testPayload.toString());
          client.close();
          done();
        });
      }, 100);
    });
  });

  test('should remove client from pool on disconnection', async () => {
    const client = await createWebSocketConnection();
    client.close();
    
    // Wait for close event to be processed
    await new Promise(resolve => setTimeout(resolve, 100));
    
    const poolSize = wss.clients.size;
    expect(poolSize).toBe(0);
  });

  test('EventDump endpoint should return all messages for a pool', async () => {
    // Insert test data
    await new Promise((resolve) => {
      db.run(
        'INSERT INTO events (pool_id, payload) VALUES (?, ?)', 
        [HASHED_POOL_ID, Buffer.from('test message 1')],
        resolve
      );
    });

    await new Promise((resolve) => {
      db.run(
        'INSERT INTO events (pool_id, payload) VALUES (?, ?)', 
        [HASHED_POOL_ID, Buffer.from('test message 2')],
        resolve
      );
    });

    const response = await request(app)
      .get(`/EventDump/${TEST_POOL_ID}`)
      .expect('Content-Type', /application\/octet-stream/)
      .expect(200);

    // Parse the binary response
    const buffer = Buffer.from(response.body);
    let offset = 0;
    const messages = [];

    while (offset < buffer.length) {
      const length = buffer.readUInt32LE(offset);
      const id = buffer.readUInt32LE(offset + 4);
      const payload = buffer.slice(offset + 8, offset + 8 + length);
      messages.push({ id, payload: payload.toString() });
      offset += 8 + length;
    }

    expect(messages).toHaveLength(2);
    expect(messages[0].payload).toBe('test message 1');
    expect(messages[1].payload).toBe('test message 2');
  });

  test('should handle database errors gracefully', async () => {
    // Force a database error by closing the connection
    db.close();

    const response = await request(app)
      .get(`/EventDump/${TEST_POOL_ID}`)
      .expect(500);

    expect(response.text).toBe('Database error');

    // Reconnect database for cleanup
    db.open('events.db');
  });

  test('clients in different pools should not receive messages from other pools', async () => {
    // Create clients in different pools
    const client1 = await createWebSocketConnection(); // in TEST_POOL_ID
    
    // Create client in different pool
    const otherPoolClient = new WebSocket(`ws://localhost:${TEST_PORT}/other-pool`);
    await new Promise(resolve => otherPoolClient.on('open', resolve));

    // Setup message listener for other pool client
    const messagePromise = new Promise((resolve) => {
      let messageReceived = false;
      otherPoolClient.on('message', () => {
        messageReceived = true;
      });

      // Wait a bit to ensure no message is received
      setTimeout(() => {
        resolve(messageReceived);
      }, 100);
    });

    // Send message from client1
    const testPayload = Buffer.from('test message');
    client1.send(testPayload);

    // Verify other pool client didn't receive the message
    const receivedMessage = await messagePromise;
    expect(receivedMessage).toBe(false);

    client1.close();
    otherPoolClient.close();
  });
});