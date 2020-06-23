FROM alpine:latest
# Thx to hasalex
ENV LANG="C.UTF-8" \
	GOSU_VERSION="1.12"
LABEL name="BASE_EAP" \
      architecture="x86_64"  \
      maintainer="LPETERS999"
RUN set -eux \
	&& apk update \
	&& apk add --no-cache --allow-untrusted -f --force-broken-world --clean-protected -u -U -l -q -v apk-tools bash openjdk8 fontconfig ttf-dejavu wget git unzip patch grep curl xmlstarlet \
	&& ln -s -f "/usr/lib/jvm/java-1.8-openjdk/bin/javac" /usr/bin/javac \ 
	&& cd /tmp && git clone git://github.com/hasalex/eap-build.git \
	&& 	rm -rf /var/cache/apk/* \
	&& apk add --no-cache --virtual .gosu-deps ca-certificates dpkg gnupg \
	&& dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& command -v gpgconf && gpgconf --kill all || : \
	&& rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& apk del --no-network .gosu-deps \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu --version \
	&& gosu nobody true 
USER nobody
