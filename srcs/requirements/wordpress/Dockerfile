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

# Crée le dossier /var/www
RUN mkdir -p /var/www && chown -R www-data:www-data /var/www && chmod -R 755 /var/www

# Télécharge WordPress
RUN wget -O /var/www/wordpress-6.7.2-fr_FR.tar.gz https://fr.wordpress.org/wordpress-6.7.2-fr_FR.tar.gz && \
    if [ ! -s /var/www/wordpress-6.7.2-fr_FR.tar.gz ]; then \
        echo "Erreur : Téléchargement de WordPress échoué (fichier vide)" >&2; \
        exit 1; \
    fi

RUN cd /var/www && tar -xzf wordpress-6.7.2-fr_FR.tar.gz && rm wordpress-6.7.2-fr_FR.tar.gz

# Configure les permissions
RUN chown -R www-data:www-data /var/www/wordpress && \
    chmod -R 755 /var/www/wordpress /etc/php82

# Copie la configuration de PHP-FPM
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

# Augmente la limite de mémoire PHP
RUN echo "memory_limit = 256M" >> /etc/php82/php.ini

# Télécharge et installe wp-cli
RUN wget -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

# Copie le script d'initialisation
COPY conf/auto_config.sh /auto_config.sh
RUN dos2unix /auto_config.sh && chmod +x /auto_config.sh

# Définis le point d’entrée
ENTRYPOINT ["/auto_config.sh"]
