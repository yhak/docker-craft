FROM alpine:latest
LABEL Maintainer="Yori Hak <yorihak@gmail.com>" \
      Description="Craft CMS in Docker"

RUN apk -U update && \
    apk -U upgrade && \
    apk -U add \
        php7 \
        php7-fpm \
        php7-mysqli \
        php7-json \
        php7-openssl \
        php7-curl \
        php7-zlib \
        php7-xml \
        php7-phar \
        php7-intl \
        php7-dom \
        php7-xmlreader \
        php7-ctype \
        php7-mbstring \
        php7-gd \
        php7-session \
        php7-exif \
        php7-opcache \
        php7-pdo \
        php7-zip \
        php7-pdo_mysql \
        nginx \
        supervisor \
        curl \
        bash \
        git \
    && \
    ln -sf /usr/bin/php7 /usr/bin/php && \
    ln -sf /usr/sbin/php-fpm7 /usr/bin/php-fpm && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/* && \
    git clone --depth 1 https://github.com/craftcms/craft.git /var/www/craft

WORKDIR /var/www/craft

RUN composer install && \
    composer require craftcms/element-api && \
    chown -R nobody:nobody . && \
    sed -i \
       -e "s/^;clear_env.*/clear_env = no/" \
       /etc/php7/php-fpm.d/www.conf

COPY ./conf/supervisord.conf /etc/supervisord.conf
COPY ./conf/nginx /etc/nginx

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
