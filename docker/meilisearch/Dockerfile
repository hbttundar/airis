FROM ubuntu:21.04

ARG FORWARD_MEILISEARCH_PORT

COPY ./scripts/  /tmp/
COPY ./supervisord.conf /tmp/config/supervisord_meilisearch.conf
RUN chmod +x /tmp/build.sh && chmod +x /tmp/start.sh

RUN bash /tmp/build.sh

ENV MEILI_HTTP_ADDR=0.0.0.0:${FORWARD_MEILISEARCH_PORT}
EXPOSE ${FORWARD_MEILISEARCH_PORT}/tcp


ENTRYPOINT ["start.sh"]