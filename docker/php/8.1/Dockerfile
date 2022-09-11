FROM ubuntu:20.04

MAINTAINER Mads Møller <mm@napp.dk>

# Build time arguments
ARG ENV_NAME
ARG PHP_VER
ENV APP_ENV=${ENV_NAME}

ENV DEBIAN_FRONTEND=noninteractive

COPY docker/php/${PHP_VER}/build /build

RUN apt-get update \
    && apt-get upgrade -yq \
    && apt-get install -yq --no-install-recommends \
        apt-utils \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
    && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get remove --purge -y software-properties-common \
    && ls #/build/cleanup.sh


RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
        php8.1-cli \
        php8.1-fpm \
        php8.1-xdebug \
        git \
        gpg \
        unzip \
        # Extensions from PHP source
        php8.1-bcmath \
        php8.1-bz2 \
        php8.1-curl \
        php8.1-dba \
        php8.1-enchant \
        php8.1-gd \
        php8.1-gmp \
        php8.1-imap \
        php8.1-interbase \
        php8.1-intl \
        php8.1-ldap \
        php8.1-mbstring \
        php8.1-mysql \
        php8.1-odbc \
        php8.1-opcache \
        php8.1-pgsql \
        php8.1-pspell \
        php8.1-readline \
        php8.1-snmp \
        php8.1-soap \
        php8.1-sqlite3 \
        php8.1-sybase \
        php8.1-tidy \
        php8.1-xml \
        php8.1-xsl \
        php8.1-zip \
        git \
        mysql-client \
        graphicsmagick \
        imagemagick \
        ghostscript \
        unzip \
        make \
    && ls #/build/cleanup.sh

RUN apt-get update
RUN apt-get install -y php-pear php8.1-dev

RUN pecl install redis
RUN apt-get install -y php-redis \
    && ls #/build/cleanup.sh

RUN mkdir -p /run/php && chown www-data:www-data /run/php

COPY docker/php/${PHP_VER}/container /

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

EXPOSE 9000
CMD ["php-fpm8.1"]