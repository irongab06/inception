FROM alpine:3.20.5

RUN apk update 	&& apk add --no-cache nginx curl vim openssl && \
	 mkdir -p /etc/nginx/ssl  && \ 
	 openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt \
	 -keyout /etc/nginx/ssl/inception.key \
	 -subj "/C=FR/ST=PACA/L=Nice/O=42/OU=42/CN=gacavali.42.fr/UID=gacavali" && \
	 mkdir -p /var/www/wordpress && \
	 mkdir -p /var/run/nginx && \
	 adduser -S www-data -G www-data && \
	 chmod 755 /var/www/wordpress && \
	 chown -R www-data:www-data /var/www/wordpress

COPY /conf/nginx.conf /etc/nginx/nginx.conf
COPY /conf/mime.types /etc/nginx/mime.types

# EXPOSE 443:443

CMD ["nginx", "-g", "daemon off;"]
