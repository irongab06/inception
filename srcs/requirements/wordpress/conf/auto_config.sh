#!/bin/sh

touch /tmp/debug.log
echo "Démarrage du script auto_config.sh" >> /tmp/debug.log

timeout=60
count=0
until mysqladmin ping -h mariadb -u "$SQL_USER" -p"$SQL_PASSWORD" --silent; do
    echo "Attente de MariaDB... (Erreur : $(mysqladmin ping -h mariadb -u "$SQL_USER" -p"$SQL_PASSWORD" 2>&1))" >> /tmp/debug.log
    sleep 2
    count=$((count + 2))
    if [ "$count" -ge "$timeout" ]; then
        echo "Erreur : MariaDB n'est pas prêt après $timeout secondes" >&2
        exit 1
    fi
done
echo "MariaDB est prêt" >> /tmp/debug.log

sleep 10


if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "Configuration de wp-config.php..."

    cd /var/www/wordpress
    wp config create --allow-root --dbname=$SQL_DATABASE --dbuser=$SQL_USER --dbpass=$SQL_PASSWORD --dbhost=$SQL_HOST --path=/var/www/wordpress
    wp core install --url=$DOMAINE_NAME --title="Thor en vacance avec Ironman" --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASSWORD --admin_email=$ADMIN_EMAIL --path=/var/www/wordpress
    wp user create $USER1_LOGIN $USER1_MAIL --role=author --user_pass=$USER1_PASS --path=/var/www/wordpress

    WP_PATH="/var/www/wordpress"
    if ! wp core is-installed --path=$WP_PATH --allow-root; then
        echo "WordPress n'est pas encore installé. Attente..."
        exit 1
    fi

    chmod -R 775 /var/www/wordpress/
    chown -R www-data:www-data /var/www/wordpress
fi

echo "Lancement de PHP-FPM..." >> /tmp/debug.log
exec php-fpm82 -F
