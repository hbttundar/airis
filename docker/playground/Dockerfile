ARG PHP_VERSION=${PHP_VERSION}
FROM php:"${PHP_VERSION}-apache"
COPY apache2/sites-enabled /etc/apache2/sites-enabled/

ARG APP_ENV

COPY scripts/ /tmp/
COPY msmtp/msmtprc /tmp/

RUN apt-get update
RUN apt-get install -y libfreetype6-dev libjpeg-dev libmcrypt-dev libpng-dev git msmtp msmtp-mta libmemcached-dev libzip-dev  libpng-dev \
    libonig-dev libxml2-dev zip
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
&& docker-php-ext-install pdo_mysql mysqli soap opcache zip sysvsem mbstring
RUN pecl install memcached \
&& pecl install mcrypt \
&& docker-php-ext-enable memcached \
&& docker-php-ext-enable mcrypt

RUN a2enmod rewrite
RUN a2enmod headers

RUN chmod +x /tmp/buildScript.sh
RUN /tmp/buildScript.sh