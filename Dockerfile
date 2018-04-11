FROM php:7.1-fpm-alpine

ARG ZPUSH_URL=http://download.z-push.org/final/2.3/z-push-2.3.9.tar.gz
ARG ZPUSH_CSUM=07290996f00b988a95ff66932d2b8127
ARG UID=1513
ARG GID=1513

ENV TIMEZONE=Europe/Zurich \
  IMAP_SERVER=localhost \
  IMAP_PORT=143 \
  SMTP_SERVER=tls://localhost \
  SMTP_PORT=465

ADD root /

RUN set -ex \
  # Install important stuff
  && apk add --update --no-cache \
  alpine-sdk \
  autoconf \
  bash \
  imap \
  imap-dev \
  nginx \
  openssl \
  openssl-dev \
  pcre \
  pcre-dev \
  supervisor \
  tar \
  tini \
  wget
  # Install php
RUN docker-php-ext-configure imap --with-imap --with-imap-ssl \
  && docker-php-ext-install imap pcntl sysvmsg sysvsem sysvshm \
  && pecl install APCu-5.1.8 \
  && docker-php-ext-enable apcu \
  # Remove dev packages
  && apk del --no-cache \
  alpine-sdk \
  autoconf \
  openssl-dev \
  pcre-dev
  # Add user for z-push
RUN addgroup -g ${GID} zpush \
  && adduser -u ${UID} -h /opt/zpush -H -G zpush -s /sbin/nologin -D zpush \
  && mkdir -p /opt/zpush
  # Install z-push
RUN wget -q -O /tmp/zpush.tgz "$ZPUSH_URL" \
  && if [ "$ZPUSH_CSUM" != "$(md5sum /tmp/zpush.tgz | awk '{print($1)}')" ]; then echo "Wrong md5sum of downloaded file!"; exit 1; fi \
  && tar -zxf /tmp/zpush.tgz -C /opt/zpush --strip-components=1 \
  && rm /tmp/zpush.tgz \
  && chmod +x /usr/local/bin/docker-run.sh \
  && mv /opt/zpush/config.php /opt/zpush/config.php.dist \
  && mv /opt/zpush/backend/imap/config.php /opt/zpush/backend/imap/config.php.dist

VOLUME ["/state"]
VOLUME ["/config"]

EXPOSE 80

ENTRYPOINT ["/sbin/tini", "--"]
CMD /usr/local/bin/docker-run.sh
