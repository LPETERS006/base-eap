FROM alpine:latest
# Thx to hasalex
ENV LANG="C.UTF-8"
LABEL name="BASE_EAP" \
      architecture="x86_64"  \
      maintainer="LPETERS999"
RUN apk update \
	&& apk add --no-cache --allow-untrusted -f --force-broken-world --clean-protected -u -U -l -q -v apk-tools bash openjdk8 fontconfig ttf-dejavu wget git unzip patch grep curl xmlstarlet \
	&& ln -s -f "/usr/lib/jvm/java-1.8-openjdk/bin/javac" /usr/bin/javac \ 
	&& cd /tmp && git clone git://github.com/hasalex/eap-build.git \
	&& 	rm -rf /var/cache/apk/*

# add "nobody" to ALL groups (makes testing edge cases more interesting)
RUN cut -d: -f1 /etc/group | xargs -n1 addgroup nobody

RUN { \
		echo '#!/bin/sh'; \
		echo 'set -ex'; \
		echo; \
		echo 'spec="$1"; shift'; \
		echo; \
		echo 'expec="$1"; shift'; \
		echo 'real="$(gosu "$spec" id -u):$(gosu "$spec" id -g):$(gosu "$spec" id -G)"'; \
		echo '[ "$expec" = "$real" ]'; \
		echo; \
		echo 'expec="$1"; shift'; \
		# have to "|| true" this one because of "id: unknown ID 1000" (rightfully) having a nonzero exit code
		echo 'real="$(gosu "$spec" id -un):$(gosu "$spec" id -gn):$(gosu "$spec" id -Gn)" || true'; \
		echo '[ "$expec" = "$real" ]'; \
	} > /usr/local/bin/gosu-t \
	&& chmod +x /usr/local/bin/gosu-t

COPY gosu /usr/local/bin/

# adjust users so we can make sure the tests are interesting
RUN chgrp nobody /usr/local/bin/gosu \
	&& chmod +s /usr/local/bin/gosu
USER nobody
ENV HOME /omg/really/gosu/nowhere
# now we should be nobody, ALL groups, and have a bogus useless HOME value

RUN id

RUN gosu-t 0 "0:0:$(id -G root)" "root:root:$(id -Gn root)"
RUN gosu-t 0:0 '0:0:0' 'root:root:root'
RUN gosu-t root "0:0:$(id -G root)" "root:root:$(id -Gn root)"
RUN gosu-t 0:root '0:0:0' 'root:root:root'
RUN gosu-t root:0 '0:0:0' 'root:root:root'
RUN gosu-t root:root '0:0:0' 'root:root:root'
RUN gosu-t 1000 "1000:$(id -g):$(id -g)" "1000:$(id -gn):$(id -gn)"
RUN gosu-t 0:1000 '0:1000:1000' 'root:1000:1000'
RUN gosu-t 1000:1000 '1000:1000:1000' '1000:1000:1000'
RUN gosu-t root:1000 '0:1000:1000' 'root:1000:1000'
RUN gosu-t 1000:root '1000:0:0' '1000:root:root'
RUN gosu-t 1000:daemon "1000:$(id -g daemon):$(id -g daemon)" '1000:daemon:daemon'
RUN gosu-t games "$(id -u games):$(id -g games):$(id -G games)" 'games:games:games users'
RUN gosu-t games:daemon "$(id -u games):$(id -g daemon):$(id -g daemon)" 'games:daemon:daemon'

RUN gosu-t 0: "0:0:$(id -G root)" "root:root:$(id -Gn root)"
RUN gosu-t '' "$(id -u):$(id -g):$(id -G)" "$(id -un):$(id -gn):$(id -Gn)"
RUN gosu-t ':0' "$(id -u):0:0" "$(id -un):root:root"

RUN [ "$(gosu 0 env | grep '^HOME=')" = 'HOME=/root' ]
RUN [ "$(gosu 0:0 env | grep '^HOME=')" = 'HOME=/root' ]
RUN [ "$(gosu root env | grep '^HOME=')" = 'HOME=/root' ]
RUN [ "$(gosu 0:root env | grep '^HOME=')" = 'HOME=/root' ]
RUN [ "$(gosu root:0 env | grep '^HOME=')" = 'HOME=/root' ]
RUN [ "$(gosu root:root env | grep '^HOME=')" = 'HOME=/root' ]
RUN [ "$(gosu 0:1000 env | grep '^HOME=')" = 'HOME=/root' ]
RUN [ "$(gosu root:1000 env | grep '^HOME=')" = 'HOME=/root' ]
RUN [ "$(gosu 1000 env | grep '^HOME=')" = 'HOME=/' ]
RUN [ "$(gosu 1000:0 env | grep '^HOME=')" = 'HOME=/' ]
RUN [ "$(gosu 1000:root env | grep '^HOME=')" = 'HOME=/' ]
RUN [ "$(gosu games env | grep '^HOME=')" = 'HOME=/usr/games' ]
RUN [ "$(gosu games:daemon env | grep '^HOME=')" = 'HOME=/usr/games' ]

# make sure we error out properly in unexpected cases like an invalid username
RUN ! gosu bogus true
RUN ! gosu 0day true
RUN ! gosu 0:bogus true
RUN ! gosu 0:0day true

# something missing?  some other functionality we could test easily?  PR! :D