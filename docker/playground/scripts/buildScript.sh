#!/bin/bash
set -e
echo $APP_ENV
echo "--------"
echo $APP_ENV
echo "--------"
echo $APP_ENV
echo "--------"
echo $APP_ENV
echo "--------"
echo $APP_ENV
echo "--------"
echo $APP_ENV
echo "--------"
echo $APP_ENV
echo "--------"
echo $APP_ENV
echo "--------"
echo $APP_ENV
echo "--------"
echo $APP_ENV
echo "--------"
echo $APP_ENV
echo "--------"
echo $APP_ENV
echo "--------"
mv /tmp/msmtprc /etc/

if [[ $APP_ENV = "local" ]]
then
    pecl install xdebug \
   && docker-php-ext-enable xdebug
fi