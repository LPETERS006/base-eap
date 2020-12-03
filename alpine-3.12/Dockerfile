FROM alpine:3.12
# Thx to hasalex
ENV LANG="C.UTF-8"
LABEL name="BASE_EAP" \
      architecture="x86_64"  \
      maintainer="LPETERS999"
RUN apk update \
	&& apk add --no-cache --allow-untrusted -f --force-broken-world --clean-protected -u -U -l -q -v apk-tools bash openjdk8 fontconfig ttf-dejavu wget git unzip patch grep curl xmlstarlet \
	&& ln -s -f "/usr/lib/jvm/java-1.8-openjdk/bin/javac" /usr/bin/javac \ 
	&& cd /tmp && git clone git://github.com/LPETERS006/eap-build.git \
	&& 	rm -rf /var/cache/apk/*

