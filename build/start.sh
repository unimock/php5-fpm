#!/bin/bash

echo "#################################################"
echo "# start: /usr/sbin/php-fpm5.6 -c /etc/php/5.6/fpm"
echo "#"

exec /usr/sbin/php-fpm5.6 -c /etc/php/5.6/fpm

