#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
#set the timezone for tzdata in ubuntu otherwise during installation ask for select timezone
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
    apache2 \
    libapache2-mod-php7.4 \
    php7.4 \
    php7.4-cli \
    php7.4-fpm \
    php7.4-dev \
    php7.4-pgsql \
    php7.4-sqlite3 \
    php7.4-gd \
    php7.4-curl \
    php7.4-memcached \
    php7.4-imap \
    php7.4-mysql \
    php7.4-pdo-mysql \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    php7.4-bcmath \
    php7.4-soap \
    php7.4-intl \
    php7.4-imagick \
    php7.4-xmlreader \
    php7.4-xmlwriter \
    php7.4-opcache \
    php7.4-readline \
    php7.4-pcov \
    php7.4-msgpack \
    php7.4-igbinary \
    php7.4-ldap \
    php7.4-redis \
    php7.4-swoole \
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
  apt-get install -yq apache2
  a2enmod rewrite
  a2enmod headers
  a2enmod expires
  a2enmod ssl
  a2enmod proxy
  a2enmod proxy_http
  a2enmod proxy_fcgi setenvif
  a2enmod php${PHP_VERSION}
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
apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*
