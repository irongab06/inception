#!/bin/sh

touch /tmp/debug.log
echo "Démarrage du script auto_config.sh" >> /tmp/debug.log

# Attendre que MariaDB soit prêt (max 60 secondes)
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

# Vérifier que wp-cli est installé
if ! command -v wp &> /dev/null; then
    echo "Erreur : wp-cli n'est pas installé" >&2
    exit 1
fi
echo "wp-cli est installé" >> /tmp/debug.log

# Vérifier les variables d'environnement
if [ -z "$SQL_DATABASE" ]; then
    echo "Erreur : Variable SQL_DATABASE manquante" >&2
    exit 1
fi
if [ -z "$SQL_USER" ]; then
    echo "Erreur : Variable SQL_USER manquante" >&2
    exit 1
fi
if [ -z "$SQL_PASSWORD" ]; then
    echo "Erreur : Variable SQL_PASSWORD manquante" >&2
    exit 1
fi
if [ -z "$ADMIN_USER" ]; then
    echo "Erreur : Variable ADMIN_USER manquante" >&2
    exit 1
fi
if [ -z "$ADMIN_EMAIL" ]; then
    echo "Erreur : Variable ADMIN_EMAIL manquante" >&2
    exit 1
fi
if [ -z "$DOMAINE_NAME" ]; then
    echo "Erreur : Variable DOMAINE_NAME manquante" >&2
    exit 1
fi
if [ -z "$USER1_LOGIN" ]; then
    echo "Erreur : Variable USER1_LOGIN manquante" >&2
    exit 1
fi
if [ -z "$USER1_MAIL" ]; then
    echo "Erreur : Variable USER1_MAIL manquante" >&2
    exit 1
fi
if [ -z "$USER1_PASS" ]; then
    echo "Erreur : Variable USER1_PASS manquante" >&2
    exit 1
fi
echo "Toutes les variables d'environnement sont présentes : SQL_DATABASE=$SQL_DATABASE, SQL_USER=$SQL_USER, DOMAINE_NAME=$DOMAINE_NAME" >> /tmp/debug.log

# Assurer les permissions de /var/www/wordpress
chown -R www-data:www-data /var/www/wordpress

# Installer WordPress si ce n'est pas déjà fait
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "Erreur : wp-config.php n'a pas été copié correctement dans /var/www/wordpress" >&2
    exit 1
fi

echo "wp-config.php est déjà présent, passage à l'installation de WordPress..." >> /tmp/debug.log

# Vérifier si WordPress est déjà installé
if ! wp core is-installed --path=/var/www/wordpress --allow-root 2>/dev/null; then
    echo "Début de la configuration de WordPress..." >> /tmp/debug.log

    # Installer WordPress
    wp core install \
        --url="https://$DOMAINE_NAME" \
        --title="$SITE_TITLE" \
        --admin_user="$ADMIN_USER" \
        --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_EMAIL" \
        --skip-email \
        --allow-root \
        --path="/var/www/wordpress" 2>&1 | tee -a /tmp/debug.log
    if [ $? -ne 0 ]; then
        echo "Erreur : Échec de l'installation de WordPress" >&2
        exit 1
    fi

    # Créer un utilisateur supplémentaire
    wp user create "$USER1_LOGIN" "$USER1_MAIL" \
        --role=author \
        --user_pass="$USER1_PASS" \
        --allow-root \
        --path="/var/www/wordpress" 2>&1 | tee -a /tmp/debug.log
    if [ $? -ne 0 ]; then
        echo "Erreur : Échec de la création de l'utilisateur supplémentaire" >&2
        exit 1
    fi
else
    echo "WordPress est déjà installé, passage au démarrage de PHP-FPM..." >> /tmp/debug.log
fi

# Préparer PHP-FPM
if [ ! -d /run/php ]; then
    mkdir -p /run/php
    chown -R nobody:nobody /run/php
fi 

# Vérifier que php-fpm82 existe
if ! command -v php-fpm82 &> /dev/null; then
    echo "Erreur : php-fpm82 non trouvé" >&2
    exit 1
fi

# Lancer PHP-FPM
echo "Lancement de PHP-FPM..." >> /tmp/debug.log
exec php-fpm82 -F






# echo "wait de MariaDB..."
# while ! nc -z mariadb 3306; do
#     sleep 1
# done
# echo "MariaDB est prêt"

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
# 		--url="$DOMAINE_NAME" \
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
# if [ ! -d /run/php ]; then
# 	mkdir -p /run/php
# 	chown -R www-data:www-data /run/php
# fi 

# if [ ! -f "/usr/sbin/php-fpm82" ]; then
# 	echo "erreur : php-fpm non trouve" >&2
# 	exit 1
# fi
# sleep 2
# # exec /usr/sbin/php-fpm82 -F 2>&1 | tee /var/log/php-fpm.log
# exec php-fpm82 -F
