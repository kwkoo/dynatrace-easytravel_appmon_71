Note: This is based off https://github.com/Dynatrace/Dynatrace-easyTravel-Docker and https://github.com/Dynatrace/Dynatrace-AppMon-Docker

To get started, execute:
docker-compose up

This setup consists of 2 containers - the first container runs the App Mon
server and the second container runs easyTravel.

easyTravel is setup to run the UEM / Standard scenario by default.

If you wish to change the scenario, point your browser to:
http://DOCKER_SERVER:8094

If you wish to access the easyTravel application, point your browser to:
http://DOCKER_SERVER:8079

Please note that this version does not automatically download and install the
easyTravel license because the easyTravel community page has not been updated
to include an App Mon 7.1 license at the time of writing (2018-04-07).

The first time that the App Mon container comes up, you will need to connect
to the App Mon server to install a valid App Mon 7.1 license using the App Mon
rich client (point the rich client to port 2021 on the DOCKER_SERVER).

The containers are setup to the Singapore timezone (UTC+8) by default. If you
are in a different timezone, you will need to change the TIMEZONE environment
variable in .env.

