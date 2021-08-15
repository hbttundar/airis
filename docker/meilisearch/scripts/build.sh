#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
#set the timezone for tzdata in ubuntu otherwise during installation ask for select timezone
export TZ=UTC
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ >/etc/timezone
apt-get update &&
  apt-get install -y \
    supervisor \
    python2 \
    init-system-helpers \
    software-properties-common &&    
echo "deb [trusted=yes] https://apt.fury.io/meilisearch/ /" > /etc/apt/sources.list.d/fury.list
echo '----------------------------------------------------------------------------------------------------------'    
echo '-------------------------------- Download and install meilisearch ----------------------------------------'    
echo '----------------------------------------------------------------------------------------------------------'    
# wget --quiet -O meilisearch https://github.com/meilisearch/MeiliSearch/releases/download/v0.20.0/meilisearch-linux-armv8 \
# 	&& chmod +x meilisearch
apt update && apt install meilisearch-http
cp /tmp/config/supervisord_meilisearch.conf /etc/supervisor/conf.d/supervisord.conf
cp /tmp/start.sh /usr/bin/start.sh  && chmod +x /usr/bin/start.sh 
echo '-----------------------------------------------------------------------------------'
echo '-------------------------- clean ubuntu container ---------------------------------'
echo '-----------------------------------------------------------------------------------'
apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*