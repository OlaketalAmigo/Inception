FROM debian:bookworm

RUN apt update && \
	apt install php-fpm php-mysql mariadb-client -y && \
	apt install curl -y && \
	rm -rf /var/lib/apt/lists/*

COPY ./script_wordpress.sh /usr/local/bin/script_wordpress.sh
RUN chmod +x /usr/local/bin/script_wordpress.sh

EXPOSE 9000

CMD ["/usr/local/bin/script_wordpress.sh"]
