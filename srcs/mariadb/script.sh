#!/bin/bash

set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    mariadbd --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0 &

    echo "Waiting for MariaDB to start..."
    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    mariadb -u root <<-EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE_NAME};
CREATE USER IF NOT EXISTS '${MYSQL_USER_NAME}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE_NAME}.* TO '${MYSQL_USER_NAME}'@'%';
CREATE USER IF NOT EXISTS '${MYSQL_USER_NAME}'@'localhost' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE_NAME}.* TO '${MYSQL_USER_NAME}'@'localhost';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
fi

exec mariadbd --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
