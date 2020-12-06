FROM nginx:stable-alpine

COPY ./build/web /usr/share/nginx/html/timecard
COPY ./nginx/default.conf.template /etc/nginx/conf.d/default.conf.template

CMD sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"

