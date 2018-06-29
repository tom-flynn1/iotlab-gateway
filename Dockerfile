# https://github.com/influxdata/influxdata-docker/tree/master/influxdb/1.5/alpine
FROM resin/raspberrypi3-debian:stretch

# Defines our working directory in container
RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app

RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install apt-utils mosquitto build-essential libssl-dev python git apt-transport-https lsb-release
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash && \
  apt-get -y install nodejs && \
  JOBS=MAX npm install -g --production --unsafe-perm --silent \
    node-red \
    node-red-contrib-influxdb \
    node-red-contrib-mapper \
    node-red-contrib-resinio \
    node-red-contrib-ttn \
    node-red-dashboard \
    node-red-node-serialport
RUN curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add - && \
  echo "deb https://repos.influxdata.com/debian stretch stable" | sudo tee /etc/apt/sources.list.d/influxdb.list && \
  sudo apt-get update && \
  sudo apt-get install influxdb
RUN apt-get autoremove -y build-essential && \
  rm -rf /var/lib/apt/lists/*

# Enable systemd init system in container
ENV INITSYSTEM=on
COPY mosquitto.service /etc/systemd/system/mosquitto.service
RUN systemctl enable /etc/systemd/system/mosquitto.service
COPY ./nodered/app ./

CMD ["bash", "/usr/src/app/start.sh"]
