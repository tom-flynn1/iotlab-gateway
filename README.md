# IoT-Lab gateway

I've bootstrapped this project in order to have a standalone IoT gateway.
My intention is to use it as an educational tool to support exercises.
Therefore, there is no security and user management is reduced to the minimum.

## Services

* MQTT (Mosquitto)
* Data broker (Node-RED)
* Time series storage (InfluxDB)
* Visualisation (Grafana)

### Exposed ports

* TCP/80: HTTP
  * `http://<gateway>/red`: Node-RED editor
  * `http://<gateway>/red/ui`: Node-RED dashboard
  * `http://<gateway>/grafana`: Grafana
* TCP/1883: MQTT
* TCP/8086: InfluxDB HTTP API

Where `<gateway>` should be replaced by the IP address of the gateway.

## WiFi access point

Use the following credentials to connect:

* SSID: `iotlab-ap`
* Key: `iotlab`

## User management

A training user can be created or removed thanks to some scripts

* `create-user.PS1`
* `remove-user.PS1`

The following script do the same for users training1..training12

* `create-training-user-set.PS1`
* `remove-training-user-set.PS1`

### Node-RED

The Node-RED instance is shared among all users.
Pay attention not to mess with someone else's flows.

Suggestion: prefix your MQTT topics name with your username

```
<username>-<flow-name>
```

### Grafana

Each user will have its own Grafana Organization named after his/her username.


### MQTT

The Mosquitto instance is shared among all users.
Pay attention not to mess with someone else's topics.

Suggestion: prefix your MQTT topics name with your username

```
<username>/+/+/+
```

### InfluxDB

There is no authentication on this InfluxDB instance.
The user creation script will only create a database with the username.

## License

Copyright 2018 FabLab Mons.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
