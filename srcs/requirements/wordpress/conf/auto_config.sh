#!/bin/sh

# SQL_DATABASE="${SQL_DATABASE:-wordpress}"
# SQL_USER="${SQL_USER:-root}"
# SQL_PASSWORD="${SQL_PASSWORD:-rootpassword}"
# ADMIN_USER="${ADMIN_USER:-admin}"
# ADMIN_PASSWORD="${ADMIN_PASSWORD:-adminpass}"
# ADMIN_EMAIL="${ADMIN_USER:-admin@exemple.com}"
# DOMAIN_NAME="${DOMAINE_MAIN:-localhost}"
# SITE_TITLE="${SITE_TITLE:--Mon blog}"
# USER1_LOGIN="${USER1_LOGIN:-user1}"
# USER1_EMAIL="${USER1_EMAIL:-user1@exemple.com}"
# USER1_PASS="${USER1_PASS:-user1pass}"

echo "wait de MariaDB..."
while ! nc -z mariadb 3306; do
    sleep 1
done
echo "MariaDB est prêt"

# sleep 10

# if ! command -v wp &> /dev/null; then
# 	echo "erreur : WP n est pas installe" >&2
# 	exit 1
# fi

# if [ -z "$SQL_DATABASE" ] || [ -z "$SQL_USER" ] || [ -z "$SQL_PASSWORD" ] || [ -z "$ADMIN_USER" ] || [ -z "$ADMIN_EMAIL" ]; then
# 	echo "erreur : variables absentes" >&2
# 	exit 1
# fi  


# if [ ! -f /var/www/wordpress/wp-config.php ]; then
# 	echo "debut config"
# 	php82 /usr/local/bin/wp config create --allow-root\
# 			--dbname="$SQL_DATABASE" \
# 			--dbuser="$SQL_USER" \
# 			--dbpass="$SQL_PASSWORD" \
# 			--dbhost="mariadb:3306" \
# 			--path="/var/www/wordpress"

# 	sleep 2

# 	php82 /usr/local/bin/wp core install \
# 		--url="$DOMAIN_NAME" \
# 		--title="$SITE_TITLE" \
# 		--admin_user="$ADMIN_USER" \
# 		--admin_password="$ADMIN_PASSWORD" \
# 		--admin_email="$ADMIN_EMAIL" \
# 		--allow-root \
# 		--path="/var/www/wordpress"
	
	
# 	php82 /usr/local/bin/wp user create \
# 		--allow-root \
# 		--role=author \
# 		"$USER1-LOGIN" "$USER1_MAIL" \
# 		--user_pass="$USER1_PASS" \
# 		--path="/var/www/wordpress" >> /log.txt 
	
# fi
echo "test ICI ICI ICI ICI"
if [ ! -d /run/php ]; then
	mkdir -p /run/php
	chown -R www-data:www-data /run/php
fi 

if [ ! -f "/usr/sbin/php-fpm82" ]; then
	echo "erreur : php-fpm non trouve" >&2
	exit 1
fi
sleep 2
# exec /usr/sbin/php-fpm82 -F 2>&1 | tee /var/log/php-fpm.log
# exec php-fpm82 -F