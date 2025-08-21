FROM debian:bookworm

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y php7.4 \
    php7.4-mysql \
    php7.4-cli \
    php7.4-mbstring \
    php7.4-fpm \
    php7.4-gettext \
    mariadb-client \
    wget \
    curl

RUN rm -rf /etc/php/7.4/fpm/pool.d/www.conf
RUN mkdir -p /run/php

COPY ./config/www.conf /etc/php/7.4/fpm/pool.d/
COPY ./tools/wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress.sh

ENTRYPOINT ["sh", "/usr/local/bin/wordpress.sh"]
CMD ["/usr/sbin/php-fpm7.4", "-F"]
