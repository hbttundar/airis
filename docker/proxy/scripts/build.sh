#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
#set the timezone for tzdata in ubuntu otherwise during installation ask for select timezone
export TZ=UTC

ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ >/etc/timezone
apt-get update &&
  apt-get install -y \
    gnupg \
    gosu \
    curl \
    zip \
    unzip \
    git \
    supervisor \
    sqlite3 \
    libsqlite3-dev \
    libcap2-bin \
    libpng-dev \
    python2 \
    bash \
    git \
    init-system-helpers \
    autoconf \
    automake \
    msmtp \
    msmtp-mta \
    libmcrypt-dev \
    apt-utils \
    ssl-cert \
    openssl
echo '-----------------------------------------------------------------------------------'
echo '--------------------------- config web server -------------------------------------'
echo '-----------------------------------------------------------------------------------'
if [ "$DEFAULT_WEB_SERVER" = "apache2" ]; then
  echo -e "${YELLOW}install apache2 server and config it"
  apt-get install -yq apache2 && \
  a2enmod rewrite && \
  a2enmod headers && \
  a2enmod expires && \
  a2enmod ssl && \
  a2enmod proxy && \
  a2enmod proxy_http && \
  cp /tmp/config/supervisord_apache2.conf /etc/supervisor/conf.d/supervisord.conf
  echo -e "${YELLOW}apache2 install sucessfully"
  source /etc/apache2/envvars
  export APACHE_RUN_DIR=${APACHE_RUN_DIR:-"/var/run/apache2"}
  mv /var/www/html/index.html /var/www/html/index.html.bak
fi
if [ "$DEFAULT_WEB_SERVER" = "nginx" ]; then
  echo -e "${YELLOW}install nginx server and config it"
  apt-get install -yq net-tools nginx
  cp /tmp/config/supervisord_nginx.conf /etc/supervisor/conf.d/supervisord.conf
  echo -e "${YELLOW}nginx install sucessfully"
fi

apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*
