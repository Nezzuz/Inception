FROM mariadb:11.7.2

COPY /tools/docker-entrypoint.sh /usr/local/bin/custom-entrypoint.sh
COPY /config/init.sql.template /docker-entrypoint-initdb.d/init.sql.template

RUN chmod +x /usr/local/bin/custom-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["mariadbd"]

