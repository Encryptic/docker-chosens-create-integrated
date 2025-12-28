# syntax=docker/dockerfile:1

FROM eclipse-temurin:21-jdk-noble

LABEL version="1.2.6"
ARG PACK_ID=1409114
ENV PACK_ID=${PACK_ID}
ARG PACK_VERSION=7386061
ENV PACK_VERSION=${PACK_VERSION}

RUN apt-get update && apt-get install -y curl unzip jq && \
    adduser --uid 99 --gid 100 --home /data --disabled-password minecraft && \
    curl -JL -o server_files.zip "https://www.curseforge.com/api/v1/mods/${PACK_ID}/files/${PACK_VERSION}/download" && \
    mkdir -p /modpack && mkdir -p /logs && \
    unzip -q server_files.zip -d /tmp/modpack && \
    mv /tmp/modpack/*/* /modpack && \
    chmod +x /modpack/startserver.sh && \
    CI_INSTALL_ONLY=true /modpack/startserver.sh && \
    rm server_files.zip

COPY launch.sh /modpack/launch.sh
RUN chmod +x /modpack/launch.sh

USER minecraft

VOLUME /data
WORKDIR /data
 
EXPOSE 25565/tcp

CMD ["/modpack/launch.sh"]
