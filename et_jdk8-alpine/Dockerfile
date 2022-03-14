FROM adoptopenjdk/openjdk8:alpine

ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:8-jdk-alpine $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}" \
    LANG="C.UTF-8" \
    JAVA_OPTS="-Xms2048m -Xmx40968m"
LABEL name="BASE_EAP" version="et_jdk8-alpine" architecture="x86_64" maintainer="LPETERS999"
RUN apk update \
  && apk add --no-cache --allow-untrusted -f --force-broken-world --clean-protected -u -U -l -q -v gcompat tzdata musl-locales musl-locales-lang apk-tools bash fontconfig ttf-dejavu wget git unzip zip patch grep curl xmlstarlet \
  && cd /tmp && git clone git://github.com/LPETERS006/eap-build.git \
  && rm -rf /var/cache/apk/*
