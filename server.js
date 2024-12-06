// @ts-check
const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const crypto = require('crypto');
const WebSocket = require('ws');
const http = require('http');

// Initialize Express app
const app = express();

// Add this to your existing server code
app.use(express.static('public')); // Serve static files from 'public' directory

// Serve the drawing app at the root path
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/index.html');
});

const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

// Initialize SQLite database
const db = new sqlite3.Database('.data/events.db', (err) => {
    if (err) {
        console.error('Database initialization error:', err);
    }
});

// Create events table
db.run(`
    CREATE TABLE IF NOT EXISTS events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pool_id TEXT NOT NULL,
        payload BLOB
    )
`);

// Helper function to hash pool ID
function hashPoolId(id) {
    return crypto.createHash('sha256').update(id).digest('hex');
}

// Helper function to create binary message
function createBinaryMessage(id, payload) {
    const idBuffer = Buffer.alloc(4);
    idBuffer.writeUInt32LE(id);

    const lengthBuffer = Buffer.alloc(4);
    lengthBuffer.writeUInt32LE(payload.length);

    return Buffer.concat([lengthBuffer, idBuffer, payload]);
}

// Store WebSocket clients for each pool
/** @type {Map<string, Set<WebSocket>>} */
const poolClients = new Map();
/** @type {Map<string, Set<WebSocket>>} */
const audioClients = new Map();

// Handle WebSocket connections
wss.on('connection', (ws, req) => {
    if (req.url === undefined) return;
    const poolId = req.url.split('/').pop();
    const hashedPoolId = hashPoolId(poolId);

    if (/^\/audio\//.test(req.url)) {
        {
            const clientSet = audioClients.get(hashedPoolId);
            if (clientSet === undefined) {
                audioClients.set(hashedPoolId, new Set([ws]));
            } else clientSet.add(ws);
        }

        const pingInterval = setInterval(() => {
            ws.ping()
        }, 5000)

        ws.on('message', (payload) => {
            const clientSet = audioClients.get(hashedPoolId)
            if (clientSet !== undefined) {
                clientSet.forEach(client => {
                    if (client === ws || client.readyState !== WebSocket.OPEN) return
                    client.send(payload)
                })
            }
        })

        ws.on('close', () => {
            const clientSet = audioClients.get(hashedPoolId)
            if (clientSet !== undefined) {
                clientSet.delete(ws)
            }
            clearInterval(pingInterval)
        })
        return
    }

    // Add client to pool
    {
        const clientSet = poolClients.get(hashedPoolId)
        if (clientSet === undefined) {
            poolClients.set(hashedPoolId, new Set([ws]));
        } else
            clientSet.add(ws);
    }

    const pingInterval = setInterval(() => {
        ws.ping()
    }, 5000)

    ws.on('message', (payload) => {
        // Store in database
        db.run('INSERT INTO events (pool_id, payload) VALUES (?, ?)',
            [hashedPoolId, payload],
            function (err) {
                if (err) {
                    console.error('Error storing event:', err);
                    return;
                }

                // Broadcast to all clients in pool except sender
                const clients = poolClients.get(hashedPoolId);
                if (clients) {
                    const broadcastMessage = createBinaryMessage(this.lastID, payload);
                    clients.forEach(client => {
                        if (client !== ws && client.readyState === WebSocket.OPEN) {
                            client.send(broadcastMessage);
                        }
                    });
                }
            }
        );
    });

    ws.on('close', () => {
        // Remove client from pool
        const clients = poolClients.get(hashedPoolId);
        if (clients) {
            clients.delete(ws);
            if (clients.size === 0) {
                poolClients.delete(hashedPoolId);
            }
        }
        clearInterval(pingInterval)
    });
});

// EventDump endpoint
app.get('/EventDump/:id', (req, res) => {
    const hashedPoolId = hashPoolId(req.params.id);

    db.all('SELECT id, payload FROM events WHERE pool_id = ? ORDER BY id',
        [hashedPoolId],
        (err, rows) => {
            if (err) {
                res.status(500).send('Database error');
                return;
            }

            // Create binary response
            const chunks = rows.map(row => {
                return createBinaryMessage(row.id, row.payload);
            });

            const response = Buffer.concat(chunks);
            res.type('application/octet-stream');
            res.send(response);
        }
    );
});

module.exports = { app, server, wss, db };
