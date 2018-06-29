# https://github.com/influxdata/influxdata-docker/tree/master/influxdb/1.5/alpine
FROM resin/raspberrypi3-alpine-node:6-slim

# Defines our working directory in container
RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app

ENV INFLUXDB_VERSION 1.5.4
RUN apk add --no-cache make gcc g++ python git && \
  JOBS=MAX npm install -g --production --unsafe-perm --silent \
    node-red \
    node-red-contrib-influxdb \
    node-red-contrib-mapper \
    node-red-contrib-resinio \
    node-red-contrib-ttn \
    node-red-dashboard \
    node-red-node-serialport \
    && \
  apk del .build-deps make gcc g++ && \
  npm cache clean --force && rm -rf /tmp/*

# This will copy all files in our root to the working  directory in the container
COPY ./app ./

# Enable systemd init system in container
# ENV INITSYSTEM=on

# server.js will run when container starts up on the device
CMD ["bash", "/usr/src/app/start.sh"]
