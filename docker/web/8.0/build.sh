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
    apt-utils &&
  mkdir -p ~/.gnupg &&
  chmod 600 ~/.gnupg &&
  echo "disable-ipv6" >>~/.gnupg/dirmngr.conf &&
  apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E5267A6C &&
  apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C300EE8C &&
  echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu hirsute main" >/etc/apt/sources.list.d/ppa_ondrej_php.list &&
  sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile &&
  apt-get update &&
  apt-get install -y \
    ca-certificates \
    php8.0 \
    php8.0-cli \
    php8.0-fpm \
    php8.0-dev \
    php8.0-pgsql \
    php8.0-sqlite3 \
    php8.0-gd \
    php8.0-curl \
    php8.0-memcached \
    php8.0-imap \
    php8.0-mysql \
    php8.0-pdo-mysql \
    php8.0-mbstring \
    php8.0-xml \
    php8.0-zip \
    php8.0-bcmath \
    php8.0-soap \
    php8.0-intl \
    php8.0-imagick \
    php8.0-xmlreader \
    php8.0-xmlwriter \
    php8.0-opcache \
    php8.0-readline \
    php8.0-pcov \
    php8.0-msgpack \
    php8.0-igbinary \
    php8.0-ldap \
    php8.0-redis \
    php8.0-swoole \
    libapache2-mod-php8.0 \
    ssl-cert \
    openssl &&
  php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer &&
  curl -sL https://deb.nodesource.com/setup_16.x | bash - &&
  apt-get install -y nodejs &&
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&
  echo "deb https://dl.yarnpkg.com/debian/ stable main" >/etc/apt/sources.list.d/yarn.list &&
  apt-get update &&
  apt-get install -y yarn &&
  apt-get install -y mysql-client &&
  apt-get install -y postgresql-client
if [ "$APP_ENV" = "local" ]; then
  if [ "$INSTALL_XDEBUG" = "true" ]; then
    echo '-----------------------------------------------------------------------------------'
    echo '------------- you select to install x-debug ---------------------------------------'
    echo '-----------------------------------------------------------------------------------'
    apt-get install -yq --no-install-recommends php-xdebug
  fi
else
  cp /tmp/msmtprc /etc/msmtprc
fi
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
  a2enmod proxy_connect && \
  a2enmod proxy_fcgi setenvif && \
  a2enmod http2 && \
  a2enmod remoteip && \
  a2enmod php${PHP_VERSION} && \
  a2enconf ssl-params
  cp /tmp/config/supervisord_apache2.conf /etc/supervisor/conf.d/supervisord.conf
  echo -e "${YELLOW}apache2 install sucessfully"
fi
if [ "$DEFAULT_WEB_SERVER" = "nginx" ]; then
  echo -e "${YELLOW}install nginx server and config it"
  apt-get install  -yq net-tools nginx
  cp /tmp/config/supervisord_nginx.conf /etc/supervisor/conf.d/supervisord.conf
  echo -e "${YELLOW}nginx install sucessfully"
fi
echo '-----------------------------------------------------------------------------------'
echo '-------------------------- clean ubuntu container ---------------------------------'
echo '-----------------------------------------------------------------------------------'
rm -rf /tmp/config
apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*
