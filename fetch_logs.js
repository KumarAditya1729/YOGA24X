const https = require('https');
const fs = require('fs');

const url = 'https://api.github.com/repos/KumarAditya1729/YOGA24X/actions/jobs/85378084501/logs';

const options = {
  headers: {
    'User-Agent': 'Node.js'
  }
};

https.get(url, options, (res) => {
  if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
    https.get(res.headers.location, options, (res2) => {
      let data = '';
      res2.on('data', chunk => data += chunk);
      res2.on('end', () => console.log(data.slice(-2000)));
    });
  } else {
    let data = '';
    res.on('data', chunk => data += chunk);
    res.on('end', () => console.log(data));
  }
}).on('error', err => console.error(err));
