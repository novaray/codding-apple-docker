const express = require('express');
const app = express();

const server = app.listen(8080, () => {
  console.log('Server running on port 8080');
});

app.get('/', (req, res) => {
  res.send('안녕냄ㅁㅇㄴ뚜!');
});

// docker가 컨테이너를 끌 때 graceful shutdown을 하기 위해 아래와 같이 작성. docker에서 던지는 메시지. process kill과 동일.
process.on('SIGTERM', () => {
  // db가 있으면 db를 닫아주는 코드를 작성해야함.

  server.close(() => {
    console.log('HTTP server closed')
  });
});
// 터미널에서 ctrl + c를 누르면 SIGINT가 발생한다. 이때도 graceful shutdown을 하기 위해 아래와 같이 작성.
process.on('SIGINT', () => {
  server.close(() => {
    console.log('HTTP server closed')
  });
});
