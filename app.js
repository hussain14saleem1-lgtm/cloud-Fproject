const express = require('express');
const app = express();
const port = 3000;

// Main page - shows the team's custom message
app.get('/', (req, res) => {
  res.send(`
    <html>
      <head><title>CloudScale - Final Project</title></head>
      <body style="font-family: Arial; text-align: center; margin-top: 60px;">
        <h1>Hello There</h1>
        <p>Cloud Computing & DevOps Engineering - Final Project</p>
        <h2>
          <span style="color: green;">Hussain Saleem (4891)</span>
          &nbsp;&amp;&nbsp;
          <span style="color: red;">Ramadan Swedik (4761)</span>
        </h2>
        <p>Pod: ${require('os').hostname()}</p>
      </body>
    </html>
  `);
});

// Health endpoint - used by Kubernetes liveness & readiness probes
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});