FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	nginx \
	openssl && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.cert \
	-subj "/C=FR/ST=Paris/L=Paris/O=42/OU=student/CN=tfauve-p.42.fr"

COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
