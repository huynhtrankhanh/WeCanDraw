const { server, db } = require("./server")

// Start server
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

// Cleanup on exit
process.on('SIGINT', () => {
    db.close(() => {
        server.close(() => {
            process.exit(0);
        });
    });
});
