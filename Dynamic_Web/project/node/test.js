const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html');
  res.end(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>Node.js Application</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; }
            h1 { color: #0066cc; }
            .container { max-width: 800px; margin: 0 auto; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Hello from Node.js server!</h1>
            <p>This is a simple Node.js application.</p>
            <p>Running on port: 8082 (via Nginx proxy)</p>
            <p>Server time: ${new Date().toISOString()}</p>
        </div>
    </body>
    </html>
  `);
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
