# 코딩 애플 docker 강의 정리.

## webserver 종료시에 오래 걸리는 이유.
  - 단순하게, server를 끄는 코드가 없어서 그렇다.
  - 원래는 docker 엔진이 서버를 종료시킬 떄, 메시지를 던져 받아서 종료하는 코드를 짜놔야 한다. 업으면, 10초 뒤에 강제로 끈다.
    - `SIGTERM`을 받아서 종료하는 코드를 짜놔야 한다.
    - 터미널에서 `ctrl + c`를 받아서 종료하는 메시지인 `SIGINT`도 받아야 한다.
                                                 
## docker compose
### network
- 컨테이너 1개는 여러 네트워크에 속할 수 있음.
  - ex. (nginx, webserver), (webserver, DB)
  - 이렇게 분리를 함으로써 서비스를 더욱 안전하게 운영할 수 있음(침입의 여지를 방지).
  - `services`랑 같은 계층에 `networks`를 추가하여 네트워크를 추가할 수 있음.
```yaml
services:
  webserver:
    networks:
      - network1
      - network2
  nginx:
    networks:
      - network1
  db:
    networks:
      - network2
  # ...
networks:
  network1:
  network2:
```

### volume
  - 외부 volume을 사용하기위에 `volumes`를 사용.
  - `services`랑 같은 계층에 `volumes`를 추가하여 볼륨을 추가할 수 있음.
    - `external` 옵션의 `true`를 사용해야 새 볼륨을 생성하지 않고 외부 볼륨을 사용할 수 있음.

#### 바운드 마운트
  - 내가 만든 폴더를 volume으로 쓰려면 bind mount.
```yaml
services:
  db:
    volumes:
      - ./myfolder:/var/lib/postgresql/data
```
                                                                     
### 서비스 종료시 다시 시작할려면.
  - nodejs의 경우에는 `pm2` 라이브러리를 쓰면 쉬움.
  - nginx의 경우에는 리눅스의 systemctl 쓰면 재실행 쉬움.
  - 위의 경우를 잘 모를경우 Docker측에 세팅을 해주면 됨.
    - `restart: always`를 사용하면 컨테이너가 종료되면 자동으로 다시 시작됨.
    - `restart:unless-stopped`를 사용하면 컨테이너 꺼져도 자동 재시작. `always`랑은 다르게 Docker 엔진 껐다 킬 경우 자동 재시작 되지 않음.
 
### build
  - `build`를 먼저 진행하고, 컨테이너를 띄워달라고 할 수 있음.
```yaml
services:
  webserver:
    build: . # 원하는 Dockerfile 경로.
```
단, `docker compose up --build` 명령어를 입력해야 빌드해줌.

### watch
  - `watch`를 사용하면 파일이 변경될 때마다 자동으로 빌드해줌. `build`라는 명령어가 정의되어있어야 작동한다.
    - `sync`를 지정하면, 내 컴퓨터에 있던 코드가 변경 사항이 있으면 컨테이너에 복붙하라는 뜻.
    - `sync+restart`를 지정하면 컨테이너에 복붙+재시작.
  - `path`는 파일이 변경될 때마다 감시할 경로를 지정.
  - `target`은 컨테이너안의 복붙할 경로 지정.
  - `ignore`은 감시하지 않을 파일을 지정.
    - `.dockerignore`파일이 있으면 그 파일에 지정된 파일은 감시하지 않음. 즉, 중복으로 작성할 필요는 없다.
  - 참고로, 터미널에서 `--watch` 키워드를 붙여 실행시에 `-d`(백그라운드 실행)는 붙이지 못한다.
  - `action`명령어를 추가하여 `package.json` 파일이 바뀌었을 경우 `rebuild`를 할 수 있다.
```yaml
services:
  webserver:
    image: nodeserver:1
  build: .
  develop:
    watch:
      - action: sync+restart
        path: .
        target: /app
      - action: rebuild
        path: package.json
```

#### nodemon
  - nodejs의 경우 `nodemon`을 사용하면 `watch`를 사용하지 않아도 된다.
  - `webserver` 컨테이너 하위에 `command`를 추가하여 오버라이드(덮어쓰기)를 할 수 있다 (eg. `command: ["nodemon", "server.js"]`).
