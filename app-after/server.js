const http = require("http");
const _ = require("lodash");
http.createServer((req, res) => {
  res.end(_.capitalize("olá, supply chain!") + "\n");
}).listen(3000);
