FROM alpine:3.20.5
RUN apk update
RUN			apk add --no-cache \ 
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
			mariadb-client

RUN	id www-data || adduser -S -G www-data www-data && \
	mkdir -p /var/log/php82 && \
	touch /var/log/php82/error.log && \
	chown -R www-data:www-data /var/log/php82 && \
	chmod -R 755 /var/log/php82

RUN	wget https://fr.wordpress.org/wordpress-6.7.2-fr_FR.tar.gz -P /var/www


RUN	cd /var/www && tar -xzf wordpress-6.7.2-fr_FR.tar.gz && rm wordpress-6.7.2-fr_FR.tar.gz

RUN	chown -R www-data:www-data /var/www/wordpress
RUN	chmod -R 755 /var/www/wordpress /etc/php82
COPY	conf/www.conf	/etc/php82/php-fpm.d/www.conf

RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN	chmod +x wp-cli.phar 
RUN	mv wp-cli.phar /usr/local/bin/wp

COPY conf/auto_config.sh auto_config.sh

RUN chmod +x auto_config.sh

RUN ./auto_config.sh
# EXPOSE 9000
#ajout user ici

CMD ["php-fpm82", "-F"]
