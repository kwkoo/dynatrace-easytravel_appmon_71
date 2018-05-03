# DOCKERFILE FOR APP MON SERVER
# Modified from Martin Etmajer's file on github
FROM alpine:3.5

LABEL maintainer "Koo Kin Wai <kin.wai.koo@dynatrace.com>"

ARG TIMEZONE
ARG DT_HOME
ARG BUILD_VERSION
ARG VERSION
#ARG DT_SERVER_LICENSE_KEY_FILE_URL

ENV INSTALLER_FILE_NAME=dynatrace-server-${BUILD_VERSION}-linux-x86.jar
ENV INSTALLER_URL=https://files.dynatrace.com/downloads/OnPrem/dynaTrace/${VERSION}/${BUILD_VERSION}/${INSTALLER_FILE_NAME}

ENV DT_INSTALL_DEPS=openjdk8-jre-base
ENV DT_RUNTIME_DEPS=bash\ curl\ tzdata

RUN set -x && \
	apk update && \
	apk add --no-cache ${DT_INSTALL_DEPS} ${DT_RUNTIME_DEPS} && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
	echo "${TIMEZONE}" > /etc/timezone && \
	echo "${TIMEZONE}" > /etc/TZ && \
	date && \
    curl --insecure -L -o /tmp/${INSTALLER_FILE_NAME} ${INSTALLER_URL} && \
	java -jar /tmp/${INSTALLER_FILE_NAME} -b 64 -t ${DT_HOME} -y && \
	apk del ${DT_INSTALL_DEPS} && \
	rm -rf /tmp/*
RUN sed -i '/^-memory/,/^unsupported/c\-memory\ndemo' ${DT_HOME}/dtserver.ini && \
	sed -i '/^-memory/,/^unsupported/c\-memory\ndemo' ${DT_HOME}/dtfrontendserver.ini && \
	echo '-Dcom.dynatrace.diagnostics.filestore.numStorageThreads=1' >> ${DT_HOME}/dtserver.ini

COPY build/config/server.config.xml ${DT_HOME}/server/conf
COPY build/config/easyTravel.profile.xml ${DT_HOME}/server/conf/profiles/
COPY build/config/dashboards ${DT_HOME}/server/conf/dashboards/

ENV GLIBC_RUNTIME_DEPS=libgcc

COPY build/bin/glibc-2.21-r2.apk /tmp
COPY build/bin/glibc-bin-2.21-r2.apk /tmp

RUN apk add --no-cache ${GLIBC_RUNTIME_DEPS} && \
	apk add --allow-untrusted /tmp/glibc-2.21-r2.apk && \
	apk add --allow-untrusted /tmp/glibc-bin-2.21-r2.apk && \
	/usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
	rm -rf /tmp/*

# Make sure that hostname resolution looks up /etc/hosts prior to /etc/resolv.conf
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

#COPY build/scripts/pull-license-key-file.sh ${DT_HOME}
COPY build/scripts/run-server-process.sh ${DT_HOME}

ENV DT_HOME=${DT_HOME}
#ENV DT_SERVER_LICENSE_KEY_FILE_URL=${DT_SERVER_LICENSE_KEY_FILE_URL}
#CMD [ "sh", "-c", "${DT_HOME}/pull-license-key-file.sh ; ${DT_HOME}/run-server-process.sh" ]
CMD [ "sh", "-c", "${DT_HOME}/run-server-process.sh" ]
