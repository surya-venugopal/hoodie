const express = require('express');
const app = express();

// Serve static files from a directory (optional)
app.use(express.static('public'));

// Define a route that renders your HTML page
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
});

// Start the server on a specific port
const port = 3000; // or any other port of your choice
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});