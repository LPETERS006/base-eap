FROM eclipse-temurin:8-jdk-alpine

ENV LANG="C.UTF-8" \
    JAVA_OPTS="-Xms2048m -Xmx40968m"
LABEL name="BASE_EAP" version="et_jdk8-alpine" architecture="x86_64" maintainer="LPETERS999"
RUN apk update \
  && apk add --no-cache --allow-untrusted -f --force-broken-world --clean-protected -u -U -l -q -v apk-tools bash fontconfig ttf-dejavu wget git unzip zip patch grep curl xmlstarlet \
  && cd /tmp && git clone git://github.com/LPETERS006/eap-build.git \
  && rm -rf /var/cache/apk/*
