FROM adoptopenjdk/openjdk11:alpine-jre

LABEL maintainer "itzg"

RUN apk add --no-cache -U \
  openssl \
  imagemagick \
  lsof \
  su-exec \
  shadow \
  bash \
  curl iputils wget \
  git \
  jq \
  mysql-client \
  tzdata \
  rsync \
  nano

HEALTHCHECK --start-period=1m CMD mc-monitor status --host localhost --port $SERVER_PORT

RUN addgroup -g 1000 minecraft \
  && adduser -Ss /bin/false -u 1000 -G minecraft -h /home/minecraft minecraft \
  && mkdir -m 777 /data /mods /config /plugins \
  && chown minecraft:minecraft /data /config /mods /plugins /home/minecraft

EXPOSE 25565

COPY Valhelsia_SERVER-2.1.4 /home/minecraft/server
COPY eula.txt /home/minecraft/server/eula.txt
COPY entrypoint.sh /home/minecraft/entrypoint.sh

RUN chmod +x /home/minecraft/server/ServerStart.sh && \
    chown -R minecraft.minecraft /home/minecraft/server


USER minecraft
WORKDIR /home/minecraft/server

ENTRYPOINT [ "/home/minecraft/entrypoint.sh" ]
# CMD [ "/home/minecraft/server/ServerStart.sh" ]
