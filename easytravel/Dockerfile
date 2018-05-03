FROM debian:jessie

LABEL maintainer "Koo Kin Wai <kin.wai.koo@dynatrace.com>"

ARG TIMEZONE
ARG BUILD_VERSION
ARG VERSION
ARG EASYTRAVEL_VERSION
ARG EASYTRAVEL_BUILD
ARG DT_SERVER_NAME
ARG APPMON_COLLECTOR_PORT

#ARG AGENT_DOWNLOAD_URL=http://192.168.1.101:8080/tmp
ARG AGENT_DOWNLOAD_URL=https://files.dynatrace.com/downloads/OnPrem/dynaTrace/${VERSION}/${BUILD_VERSION}
ARG AGENT_INSTALLER_FILE_NAME=dynatrace-agent-${BUILD_VERSION}-unix.jar
ARG WSAGENT_INSTALLER_FILE_NAME=dynatrace-wsagent-${BUILD_VERSION}-linux-x86-64.tar

ARG EASYTRAVEL_INSTALLER_FILE_NAME=dynatrace-easytravel-linux-x86_64-${EASYTRAVEL_VERSION}.${EASYTRAVEL_BUILD}.jar
ARG EASYTRAVEL_DOWNLOAD_URL=https://s3.amazonaws.com/easytravel/dT71/${EASYTRAVEL_INSTALLER_FILE_NAME}
#ARG EASYTRAVEL_DOWNLOAD_URL=http://192.168.1.101:8080/tmp/${EASYTRAVEL_INSTALLER_FILE_NAME}

ARG EASYTRAVEL_DIR=/opt/easytravel-${EASYTRAVEL_VERSION}-x64
ARG DTAGENT_DIR=/opt/dynatrace-${VERSION}


ARG DT_INSTALL_DEPS=openjdk-8-jre-headless
ARG DT_RUNTIME_DEPS=netcat\ curl\ procps\ libstdc++6:i386\ libaprutil1:i386

COPY wait-for-cmd.sh /
COPY run-easytravel.sh /

RUN set -x && \
	chmod 755 /wait-for-cmd.sh && \
	chmod 755 /run-easytravel.sh && \
	rm -f /etc/localtime && \
	ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone && \
	date && \
	dpkg --add-architecture i386 && \
	echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get install -y ${DT_RUNTIME_DEPS} && \
	apt-get install -y -t jessie-backports ${DT_INSTALL_DEPS} && \
	cd /lib/i386-linux-gnu && \
	ln -s libexpat.so.1 libexpat.so.0 && \
	curl --insecure -L -o /tmp/${WSAGENT_INSTALLER_FILE_NAME} ${AGENT_DOWNLOAD_URL}/${WSAGENT_INSTALLER_FILE_NAME} && \
	curl --insecure -L -o /tmp/${AGENT_INSTALLER_FILE_NAME} ${AGENT_DOWNLOAD_URL}/${AGENT_INSTALLER_FILE_NAME} && \
	curl --insecure -L -o /tmp/${EASYTRAVEL_INSTALLER_FILE_NAME} ${EASYTRAVEL_DOWNLOAD_URL} && \
	cd /tmp/ && \
	tar -xvf ${WSAGENT_INSTALLER_FILE_NAME} && \
	cd /opt/ && \
	tar -xvf /tmp/${WSAGENT_INSTALLER_FILE_NAME} && \
	./dynatrace-wsagent-${BUILD_VERSION}-linux-x64.sh && \
	sed -i 's/^Server .*/Server dtserver/' /opt/dynatrace-${VERSION}/agent/conf/dtwsagent.ini && \
	java -jar /tmp/${AGENT_INSTALLER_FILE_NAME} -y -t /opt/dynatrace-${VERSION} && \
	java -jar /tmp/${EASYTRAVEL_INSTALLER_FILE_NAME} -t /opt/easytravel-${EASYTRAVEL_VERSION}-x64 && \
	sed -i 's/^config\.dtServer=.*/config.dtServer=dtserver/;s/^config\.apmServerProtocol/#config.apmServerProtocol/;s/^config\.apmServerHost/#config.apmServerHost/;s/^config\.apmServerWebPort/#config.apmServerWebPort/;s/^config\.apmServerPort/#config.apmServerPort/;s/^config\.apmServerUsername/#config.apmServerUsername/;s/^config\.apmServerPassword/#config.apmServerPassword/;s/^config\.apmServerWebURL/#config.apmServerWebURL/;s/^config\.apmTenant/#config.apmTenant/;s/^config\.autostart=.*/config.autostart=Standard/;s/^config\.autostartGroup=.*/config.autostartGroup=UEM/' /opt/easytravel-${EASYTRAVEL_VERSION}-x64/resources/easyTravelConfig.properties && \
	echo "" >> /opt/easytravel-${EASYTRAVEL_VERSION}-x64/resources/easyTravelConfig.properties && \
	sed -i "s|^SERVER=.*|SERVER=${DT_SERVER_NAME}|;s|^PORT=.*|PORT=${APPMON_COLLECTOR_PORT}|;s|^DTAGENT_DIR=.*|DTAGENT_DIR=${DTAGENT_DIR}|;s|^EASYTRAVEL_DIR=.*|EASYTRAVEL_DIR=${EASYTRAVEL_DIR}|" /run-easytravel.sh && \
	apt-get remove -y ${DT_INSTALL_DEPS} && \
	apt-get autoremove -y && \
	rm -f /tmp/${WSAGENT_INSTALLER_FILE_NAME} /opt/dynatrace-wsagent-${BUILD_VERSION}-linux-x64.sh /tmp/${AGENT_INSTALLER_FILE_NAME} /tmp/${EASYTRAVEL_INSTALLER_FILE_NAME}

CMD ["/run-easytravel.sh"]
