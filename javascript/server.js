const express = require('express');
const app = express();

app.get('/hello', (req, res) => {
  res.json({ message: 'Hello, world!' });
});

app.listen(8080, '0.0.0.0', () => {
  console.log('Server running on port 8080');
});
