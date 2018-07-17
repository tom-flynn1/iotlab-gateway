# base-image for node on any machine using a template variable,
# see more about dockerfile templates here:http://docs.resin.io/pages/deployment/docker-templates
# Note the node:slim image doesn't have node-gyp
FROM resin/raspberrypi3-alpine-node:6-slim

# Defines our working directory in container
RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app

# Install node modules, including i2c-bus without carrying all the deps in the layers
RUN apk add --no-cache make gcc g++ python git linux-headers && \
  JOBS=MAX npm install -g --production --silent \
    node-red \
    node-red-contrib-influxdb \
    node-red-contrib-mapper \
    node-red-contrib-resinio \
    node-red-contrib-ttn \
    node-red-dashboard \
    node-red-node-serialport \
    && \
  apk del make gcc g++ && \
  npm cache clean --force && rm -rf /tmp/*

# This will copy all files in our root to the working  directory in the container
COPY ./app ./
VOLUME /var/lib/node-red

# Enable systemd init system in container
# ENV INITSYSTEM=on

EXPOSE 80

# server.js will run when container starts up on the device
CMD ["bash", "/usr/src/app/start.sh"]
