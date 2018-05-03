#!/bin/bash

SERVER=${DT_SERVER_NAME:-"dtserver"}
PORT=${APPMON_COLLECTOR_PORT:-"9998"}
DTAGENT_DIR=/opt/dynatrace
EASYTRAVEL_DIR=/opt/easytravel

# We attempt to auto-discover the Dynatrace Server through the environment
# when the container has been --linked to a 'dynatrace/server' container
# instance with a link alias 'dtserver'.
#
# Example: docker run --link dtserver-1:dtserver dynatrace/collector
#
# Auto-discovery can be overridden by providing the $SERVER variable
# through the environment.

echo "Waiting for ${SERVER}:${PORT} to become available..."

# Wait for the server to start serving collectors.
/wait-for-cmd.sh "nc -z ${SERVER} ${PORT}" 360

# TODO: switch to DTAGENT_DIR
${DTAGENT_DIR}/init.d/dynaTraceWebServerAgent start

#cd ${EASYTRAVEL_DIR}
#./runEasyTravelNoGUI.sh

# TODO: switch to EASYTRAVEL_DIR
cd ${EASYTRAVEL_DIR}/weblauncher
./weblauncher.sh
