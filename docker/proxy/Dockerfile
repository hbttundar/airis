FROM ubuntu:21.04

LABEL maintainer="Hosein Bagherzadegan Talkhouncheh"

ARG DEFAULT_WEB_SERVER


COPY apache/supervisord.conf  /tmp/config/supervisord_apache2.conf
COPY nginx/supervisord.conf  /tmp/config/supervisord_nginx.conf
COPY scripts/build.sh /tmp/build.sh
COPY scripts/start.sh /usr/local/bin/start.sh
RUN chmod +x /tmp/build.sh  &&  chmod +x /usr/local/bin/start.sh
RUN bash /tmp/build.sh
#
# copy all files that we need
#
COPY apache/config/ /etc/apache2/
COPY nginx/config/ /etc/nginx/
COPY self-certificate/server.crt /etc/ssl/certs/server.crt
COPY self-certificate/server.key /etc/ssl/private/server.key

RUN update-ca-certificates


EXPOSE 80 443
#CMD tail -f /dev/null
ENTRYPOINT ["start.sh"]