# FROM alpine:3.20.5

# RUN apk update 	&& apk add --no-cache \
# 	unzip \
# 	busybox-extras

# RUN mkdir -p /var/www/html/portfolio && \
# 	adduser -S -G www-data www-data

# COPY ./conf/cv.zip /temp/cv.zip

# RUN unzip /temp/cv.zip -d /var/www/html/portfolio
# RUN chown -R  www-data:www-data /var/www/html/portfolio && \
# 	rm -rf /temp/cv.zip

# CMD ["httpd", "-f", "-p", "9000", "-h", "/var/www/html/portfolio"]

FROM alpine:3.20.5

RUN apk update 	&& apk add --no-cache \
	busybox-extras

RUN mkdir -p /var/www/html/portfolio && \
	adduser -S -G www-data www-data

COPY ./conf/* /var/www/html/portfolio

RUN chown -R  www-data:www-data /var/www/html/portfolio

CMD ["httpd", "-f", "-p", "9000", "-h", "/var/www/html/portfolio"]