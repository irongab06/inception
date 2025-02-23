#!/bin/sh

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld


if [ ! -d "/var/lib/mysql/mysql" ]; then
	chown -R mysql:mysql /var/lib/mysql
	mysql_install_db  --user=mysql --datadir=/var/lib/mysql
fi

if [ ! -d "var/lib/mysql/${SB_NAME}" ]; then
	cat << EOF >. /tmp/create.db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE user='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	/usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
	rm -f /tmp/create_db.sql
fi

exec mysqld_safe --datadir=/var/lib/mysql
