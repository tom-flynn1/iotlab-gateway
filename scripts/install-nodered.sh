#!/bin/bash

yes | bash <(curl -sL https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/update-nodejs-and-nodered)
cd ~/.node-red
JOBS=MAX npm install --unsafe-perm --production --silent \
  node-red-contrib-resinio \
  node-red-node-serialport \
  node-red-contrib-influxdb \
  node-red-contrib-mapper \
  node-red-contrib-ttn
wget https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/nodered.service -O /lib/systemd/system/nodered.service
wget https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/node-red-start -O /usr/bin/node-red-start
wget https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/node-red-stop -O /usr/bin/node-red-stop
chmod +x /usr/bin/node-red-st*
systemctl daemon-reload
systemctl enable nodered.service
