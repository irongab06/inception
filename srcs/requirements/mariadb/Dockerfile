FROM alpine:3.20.5
RUN apk update && apk upgrade && apk add --no-cache mariadb mariadb-client mariadb-server-utils 
COPY /conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY /tools/init_db.sh /init_db.sh
RUN chmod +x /init_db.sh
ENTRYPOINT ["sh", "/init_db.sh"]
EXPOSE 3306
