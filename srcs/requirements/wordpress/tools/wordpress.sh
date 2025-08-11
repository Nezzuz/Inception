#!/bin/sh

# Reemplaza el puerto PHP en el pool de configuración
sed -i "s|PHP_PORT|${PHP_PORT}|g" /etc/php/7.4/fpm/pool.d/www.conf

# Carga las variables desde secretos si existen
if [ -f /run/secrets/db_password ]; then
	export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
	echo "[Entrypoint] Loaded MYSQL_PASSWORD from secret"
fi

if [ -f /run/secrets/wp_admin_password ]; then
	export WP_PASSWORD=$(cat /run/secrets/wp_admin_password)
	echo "[Entrypoint] Loaded WP_PASSWORD from secret"
fi

if [ -f /run/secrets/wp_user_password ]; then
	export WP_USER_PASS=$(cat /run/secrets/wp_user_password)
	echo "[Entrypoint] Loaded WP_USER_PASS from secret"
fi

cd /var/www/html

if [ -f wp-config.php ]; then
	echo "WordPress already set up in $WP_PATH"
else
	echo "[Entrypoint] Setting up WordPress..."

	rm -rf *
	echo "[Entrypoint] Waiting for MariaDB to be ready..."
	until mysqladmin ping -hmariadb -uroot -prootpass --silent; do
		echo "Waiting for MariaDB..."
		sleep 2
	done
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp

	wp core download --allow-root --path=$WP_PATH

	wp config create --allow-root \
		--dbname=$MYSQL_DATABASE \
		--dbuser=$MYSQL_USER \
		--dbpass=$MYSQL_PASSWORD \
		--dbhost=mariadb \
		--path=$WP_PATH \
		--skip-check

	wp core install --allow-root \
		--path=$WP_PATH \
		--url=$DOMAIN_NAME \
		--title=$WP_TITLE \
		--admin_user=$WP_USER \
		--admin_password=$WP_PASSWORD \
		--admin_email=$WP_EMAIL \
		--skip-email

	wp user create jleon-la jleon-la@42.fr --allow-root --role=author --path=$WP_PATH --user_pass=$WP_USER_PASS
fi

echo "[Entrypoint] Starting PHP-FPM..."
exec "$@"
