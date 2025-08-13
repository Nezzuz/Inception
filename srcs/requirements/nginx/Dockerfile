FROM nginx:1.28.0

RUN mkdir -p /etc/nginx/sites-available

COPY ./conf/default.conf /etc/nginx/sites-available/default.conf
COPY ./tools/nginx.sh /usr/local/bin/nginx.sh

RUN chmod +x /usr/local/bin/nginx.sh

ENTRYPOINT ["/usr/local/bin/nginx.sh"]
CMD ["nginx", "-g", "daemon off;"]

