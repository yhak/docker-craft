#!/bin/sh

until nc -z -v -w30 database 3306
do
  echo "Waiting for database connection..."
  sleep 2
done

# Create directory to log output
mkdir -p /data/logs/supervisor

# Start supervisord which spawns nginx and php-fpm
exec /usr/bin/supervisord -n -c /etc/supervisord.conf
