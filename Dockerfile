FROM bitnami/oraclelinux-runtimes:7-php
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates cyrus-sasl-lib freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline wget xz-libs zlib nginx mariadb-libs python-setuptools && easy_install supervisor
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/php-7.2.13-0-linux-x86_64-ol-7.tar.gz && \
    echo "6538f97a065ced8478e8e9f0638f845800f2f30a199b0a12ae6641db213a19f7  /tmp/bitnami/pkg/cache/php-7.2.13-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/php-7.2.13-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/php-7.2.13-0-linux-x86_64-ol-7.tar.gz
RUN mkdir -p /bitnami && ln -sf /bitnami/php /bitnami/php-fpm
RUN mkdir /opt/bitnami/php/logs && touch /opt/bitnami/php/logs/php-fpm.log

ENV BITNAMI_APP_NAME="php-fpm" \
    BITNAMI_IMAGE_VERSION="7.2.13-ol-7-r1" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/php/sbin:$PATH"

EXPOSE 8080
WORKDIR /app

COPY supervisord.conf .
COPY nginx.conf /etc/nginx/
COPY vhost.conf /etc/nginx/conf.d/
COPY www.conf /opt/bitnami/php/etc/php-fpm.d/
ADD basic.tgz /app/

CMD [ "supervisord", "-c", "supervisord.conf" ]
