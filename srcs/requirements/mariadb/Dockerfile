FROM debian:bullseye

RUN apt update && apt install -y mariadb-server

COPY /tools/docker-entrypoint.sh /usr/local/bin/custom-entrypoint.sh
COPY /config/init.sql.template /docker-entrypoint-initdb.d/init.sql.template

RUN chmod +x /usr/local/bin/custom-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["mariadbd"]

