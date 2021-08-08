FROM ubuntu:21.04

ARG FORWARD_MEILISEARCH_PORT

WORKDIR /meilisearch

RUN apt-get update
RUN apt-get install -y\
	libc6-dev\
	wget

RUN wget --quiet -O meilisearch https://github.com/meilisearch/MeiliSearch/releases/download/v0.20.0/meilisearch-linux-armv8 \
	&& chmod +x meilisearch

ENV MEILI_HTTP_ADDR=0.0.0.0:${FORWARD_MEILISEARCH_PORT}
EXPOSE ${FORWARD_MEILISEARCH_PORT}/tcp

CMD ["/bin/sh", "-c", "./meilisearch"]