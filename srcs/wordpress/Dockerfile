FROM debian:bookworm

RUN apt update && \
	apt install php-fpm php-mysql mariadb-client -y && \
	apt install curl -y && \
	rm -rf /var/lib/apt/lists/*

COPY ./script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 9000

CMD ["/usr/local/bin/script.sh"]
