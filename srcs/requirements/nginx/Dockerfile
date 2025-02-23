FROM alpine:3.20.5
RUN apk update 	&& apk add --no-cache nginx curl vim openssl && \
	 mkdir -p /etc/nginx/ssl  && \ 
	 openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt \
	 -keyout /etc/nginx/ssl/inception.key \
	 -subj "/C=FR/ST=PACA/L=Nice/O=42/OU=42/CN=gacavali.42.fr/UID=gacavali" && \
	 mkdir -p /var/www/html && \
	 mkdir -p /var/run/nginx && \
	 adduser -S www-data -G www-data && \
	 chmod 755 /var/www/html && \
	 chown -R www-data:www-data /var/www/html
COPY /conf/nginx.conf /etc/nginx/nginx.conf
CMD ["nginx", "-g", "daemon off;"]
