#!/bin/bash
set -e
cd /var/www/html
composer self-update
composer install