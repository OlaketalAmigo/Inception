FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y mariadb-server && \
	rm -rf /var/lib/apt/lists/*

COPY ./script_mariadb.sh /usr/local/bin/script_mariadb.sh
RUN chmod +x /usr/local/bin/script_mariadb.sh

EXPOSE 3306

CMD ["/usr/local/bin/script_mariadb.sh"]
