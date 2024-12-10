FROM nginx:1.27.3-alpine

COPY ./nginx-config.conf /etc/nginx/conf.d/nginx-config.conf
RUN rm /etc/nginx/conf.d/default.conf

# 포트 오픈 80(도메인 뒤에 아무것도 없으면 80번 포트라는 뜻).
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
