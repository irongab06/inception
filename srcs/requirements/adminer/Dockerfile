FROM alpine:3.20.5

# Installer les dépendances
RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-cli \
    php82-mysqli \
    php82-json \
    php82-opcache \
    php82-curl \
    php82-xml \
    php82-zlib \
    php82-mbstring \
    php82-session \
    php82-phar \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-tokenizer \
    php82-zip \
    php82-gd \
    wget \
    mariadb-client \
    dos2unix  # Ajout de dos2unix pour éviter les erreurs de format

# Corrige le lien symbolique de PHP
RUN ln -s /usr/bin/php82 /usr/bin/php

# Crée l'utilisateur www-data et configure les logs
RUN id www-data || adduser -S -G www-data www-data && \
    mkdir -p /var/log/php82 && \
    touch /var/log/php82/error.log && \
    chown -R www-data:www-data /var/log/php82 && \
    chmod -R 755 /var/log/php82

# Créer le dossier sessions et donner les bonnes permissions
RUN mkdir -p /var/run/php-fpm && \
    chown -R www-data:www-data /var/run/php-fpm && \
    chmod 770 /var/run/php-fpm

# Crée le dossier /var/www
RUN mkdir -p /var/www && chown -R www-data:www-data /var/www && chmod -R 755 /var/www

RUN mkdir -p /var/www/html/adminer && \
	wget "https://www.adminer.org/latest.php" -O /var/www/html/adminer/index.php && \
	chown -R www-data:www-data /var/www/html/adminer

# Copie la configuration de PHP-FPM
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

# Augmente la limite de mémoire PHP
RUN echo "memory_limit = 256M" >> /etc/php82/php.ini

# Définis le point d’entrée
CMD ["php-fpm82", "-F"]
