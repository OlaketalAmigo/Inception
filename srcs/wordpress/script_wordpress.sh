#!/bin/bash

set -e

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

sed -i 's|^listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

if [ -f "/var/www/html/wp-config.php" ]; then
	echo "wordpress already configured"
else
	curl -o /tmp/wordpress-6.8.3.tar.gz https://wordpress.org/wordpress-6.8.3.tar.gz
	tar -xzvf /tmp/wordpress-6.8.3.tar.gz -C /var/www/html --strip-components=1
	rm /tmp/wordpress-6.8.3.tar.gz

	cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
	sed -i "s/database_name_here/$MYSQL_DATABASE_NAME/g" /var/www/html/wp-config.php
	sed -i "s/username_here/$MYSQL_USER_NAME/g" /var/www/html/wp-config.php
	sed -i "s/password_here/$MYSQL_USER_PASSWORD/g" /var/www/html/wp-config.php
	sed -i "s/localhost/$MYSQL_HOSTNAME/g" /var/www/html/wp-config.php

	until wp db check --allow-root --path=/var/www/html 2>/dev/null; do
		echo "Waiting for MariaDB..."
		sleep 1
	done

	wp core install --allow-root \
		--path=/var/www/html \
		--url="https://tfauve-p.42.fr" \
		--title="$WORDPRESS_TITLE" \
		--admin_user="$WORDPRESS_ADMIN_USER" \
		--admin_password="$WORDPRESS_ADMIN_PASSWORD" \
		--admin_email="$WORDPRESS_ADMIN_EMAIL"

	wp user create --allow-root \
		--path=/var/www/html \
		"$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
		--user_pass="$WORDPRESS_USER_PASSWORD" \
		--role=author
	
	chown -R www-data:www-data /var/www/html

fi

echo "Starting php-fpm"
exec /usr/sbin/php-fpm8.2 -F
