FROM thies88/base-alpine-mono

MAINTAINER thies88

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SONARR_VERSION
LABEL build_version="Alpine-base-mono:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Thies88"

# environment settings
ENV XDG_CONFIG_HOME="/config/xdg"
ENV SONARR_BRANCH="master"

RUN apk update && \
echo "**** install packages ****" && \
apk add --no-cache tar curl && \
echo "**** install sonarr packages ****" && \
apk add --no-cache jq libmediainfo && \
echo "**** install sonarr ****" && \
 mkdir -p /opt/NzbDrone && \
  if [ -z ${SONARR_VERSION+x} ]; then \
	SONARR_VERSION=$(curl -sX GET https://services.sonarr.tv/v1/download/${SONARR_BRANCH} \
	| jq -r '.version'); \
 fi && \
 curl -o \
	/tmp/sonarr.tar.gz -L \
	"https://download.sonarr.tv/v2/${SONARR_BRANCH}/mono/NzbDrone.${SONARR_BRANCH}.${SONARR_VERSION}.mono.tar.gz" && \
 tar xf \
	/tmp/sonarr.tar.gz -C \
	/opt/NzbDrone --strip-components=1 && \
 echo "**** clean up ****" && \
 apk del tar && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*
	

# add local files
COPY /root /

# ports and volumes
EXPOSE 8989
VOLUME /config /tv /downloads
