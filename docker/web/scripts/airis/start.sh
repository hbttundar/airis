#!/bin/bash
set -e
# shellcheck disable=SC1073
if [ "$APP_ENV" = "local" ]; then
  php artisan migrate --seed --force
fi
if [ ! -z "$WWWUSER" ]; then
  usermod -u $WWWUSER sail
fi

if [ ! -d /.composer ]; then
  mkdir /.composer
fi

chmod -R ugo+rw /.composer

if [ $# -gt 0 ]; then
  exec gosu $WWWUSER "$@"
else
  /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
fi
