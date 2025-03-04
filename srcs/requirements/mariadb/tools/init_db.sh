#!/bin/sh

# mkdir -p /run/mysqld
# chown -R mysql:mysql /run/mysqld


# if [ ! -d "/var/lib/mysql/mysql" ]; then
# 	chown -R mysql:mysql /var/lib/mysql
# 	mysql_install_db  --user=mysql --datadir=/var/lib/mysql
# fi

# if [ ! -d "var/lib/mysql/${SB_NAME}" ]; then
# 	cat << EOF >. /tmp/create.db.sql
# USE mysql;
# FLUSH PRIVILEGES;
# DELETE FROM mysql.user WHERE User='';
# DROP DATABASE IF EXISTS test;
# DELETE FROM mysql.db WHERE Db='test';
# DELETE FROM mysql.user WHERE user='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
# CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci
# CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
# GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
# FLUSH PRIVILEGES;
# EOF

# 	/usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
# 	rm -f /tmp/create_db.sql
# fi

# exec mysqld_safe --datadir=/var/lib/mysql


# Crée le répertoire pour le socket MySQL et ajuste les permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Vérifie si MariaDB est déjà initialisé
if [ ! -d "/var/lib/mysql/mysql" ]; then
    chown -R mysql:mysql /var/lib/mysql
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Vérifie si la base de données spécifiée existe (utilise SQL_DATABASE)
if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
    cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
CREATE DATABASE ${SQL_DATABASE} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
    rm -f /tmp/create_db.sql
fi

# Lance le serveur MariaDB
exec /usr/bin/mysqld --user=mysql --datadir=/var/lib/mysql