#!/bin/sh

: "${DOMAIN_NAME:=localhost}"
: "${MYSQL_USER:=user42}"
: "${WP_PATH:=/var/www/html}"
: "${PHP_HOST:=wordpress}"
: "${PHP_PORT:=9000}"
: "${CERTS_KEY:=/etc/ssl/private/nginx-selfsigned.key}"
: "${CERTS_CRT:=/etc/ssl/certs/nginx-selfsigned.crt}"

mkdir -p "$WP_PATH"
chown -R www-data:www-data "$WP_PATH"

if [ ! -f "$CERTS_KEY" ] || [ ! -f "$CERTS_CRT" ];
then
echo "🔐 Generando certificado SSL autofirmado..."
	mkdir -p "$(dirname "$CERTS_KEY")" "$(dirname "$CERTS_CRT")"
	openssl req -x509 -nodes -days 365 \
		-subj "/C=ES/ST=Urduliz/L=Urduliz/O=42/OU=${MYSQL_USER}/CN=${DOMAIN_NAME}" \
		-newkey rsa:2048 \
		-keyout "$CERTS_KEY" \
		-out "$CERTS_CRT"
else
	echo "✅ Certificados SSL ya existen, no se regeneran."
fi

sed -i "s|DOMAIN_NAME|${DOMAIN_NAME}|g" /etc/nginx/sites-available/default.conf
sed -i "s|WP_PATH|${WP_PATH}|g" /etc/nginx/sites-available/default.conf
sed -i "s|PHP_HOST|${PHP_HOST}|g" /etc/nginx/sites-available/default.conf
sed -i "s|PHP_PORT|${PHP_PORT}|g" /etc/nginx/sites-available/default.conf
sed -i "s|CERTS_KEY|${CERTS_KEY}|g" /etc/nginx/sites-available/default.conf
sed -i "s|CERTS_CRT|${CERTS_CRT}|g" /etc/nginx/sites-available/default.conf

if ! grep -q 'include /etc/nginx/sites-enabled/*.conf;' /etc/nginx/nginx.conf;
then
	echo "🔧 Añadiendo include sites-enabled en nginx.conf"
	sed -i '/http {/a \    include /etc/nginx/sites-enabled/*.conf;' /etc/nginx/nginx.conf
fi

echo "127.0.0.1   ${DOMAIN_NAME} jleon-la.intra.fr" >> /etc/hosts
mkdir -p /etc/nginx/sites-enabled
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

echo "🚀 Iniciando Nginx..."
exec "$@"

