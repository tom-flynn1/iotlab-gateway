# https://github.com/influxdata/influxdata-docker/tree/master/influxdb/1.5/alpine
FROM resin/raspberrypi3-debian:stretch

# Defines our working directory in container
RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app

RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install cmake libssl1.0-dev libwebsockets-dev uuid-dev mosquitto && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/*

# Enable systemd init system in container
# ENV INITSYSTEM=on

CMD ["mosquitto"]
