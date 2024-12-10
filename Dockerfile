FROM node:20-slim
WORKDIR /app
COPY package*.json .
# RUN npm install # /bin/sh -c npm install 실행됨 (OS에 있는 기본 shell 이용해서 실행하라는 뜻)
# 기본적으로 권장하는 방식은 다음과 같은 형식.
# npm ci는 package-lock.json을 바탕으로 설치.
RUN ["npm", "ci"]

# 요즘 라이브러리는 안 그러지만, 옛날 라이브러리인 경우 production 환경일 경우 성능이 향상되는 경우가 있음(로그 출력 안되는 등등).
ENV NODE_ENV=production

# 그외 소스 코드 복사.
COPY . .

# 포트 오픈 8080. 나중에 이미지 실행할 때 힌트제공용임(굳이 안 써도 됨).
EXPOSE 8080

# 마지막 터미널 명령어는 RUN 말고 CMD. ENTRYPOINT도 같음.
# 보안적으로 마지막 명령어는 코드 실행 전 유저 권한을 낮추는 것이 좋음. nodejs 이미지는 node라는 유저가 이미 있음. 그래서 그걸 사용(만들 필요 없음).
USER node
CMD ["node", "server.js"]

# COPY나 RUN같은 경우에는 docker에서 캐싱을 하기 때문에, COPY나 RUN이 변경되지 않으면 이전 결과를 그대로 사용함.
# 그러기 떄문에 잘 안 변하는 것들은 위쪽에, 자주 변하는 것들은 아래쪽에 배치하는 것이 좋음.
# package.json, 라이브러리 파일은 변동사항이 별로 없음.
  # package.json 파일 먼저 옮기기
  # npm install 실행
  # 소스코드 옮기고 실행.
