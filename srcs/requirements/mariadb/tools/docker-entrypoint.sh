#!/bin/bash

set -e

echo "[Entrypoint] Custom MariaDB entrypoint starting..."

if [ -f /run/secrets/db_password ];
then
	export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
	echo "[Entrypoint] Loaded MYSQL_PASSWORD from secret"
fi

if [ -f /run/secrets/db_root_password ];
then
	export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
	echo "[Entrypoint] Loaded MYSQL_ROOT_PASSWORD from secret"
fi

echo "[DEBUG] MYSQL_PASSWORD: $MYSQL_PASSWORD"
echo "[DEBUG] MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD"

if [ -f /docker-entrypoint-initdb.d/init.sql.template ];
then
	echo "[Entrypoint] Processing init.sql.template..."
	sed -i "s|\${MYSQL_DATABASE}|${MYSQL_DATABASE}|g" /docker-entrypoint-initdb.d/init.sql.template
	sed -i "s|\${MYSQL_USER}|${MYSQL_USER}|g" /docker-entrypoint-initdb.d/init.sql.template
	sed -i "s|\${MYSQL_PASSWORD}|${MYSQL_PASSWORD}|g" /docker-entrypoint-initdb.d/init.sql.template
	sed -i "s|\${MYSQL_ROOT_PASSWORD}|${MYSQL_ROOT_PASSWORD}|g" /docker-entrypoint-initdb.d/init.sql.template

	mv /docker-entrypoint-initdb.d/init.sql.template /docker-entrypoint-initdb.d/init.sql

	echo "[Entrypoint] Generated init.sql"
fi

echo "[Entrypoint] Delegating to official MariaDB entrypoint..."
exec /usr/local/bin/docker-entrypoint.sh "$@"

