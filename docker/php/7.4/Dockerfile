#FROM composer:1.10.23 AS composer
#LABEL author="noone"

FROM ubuntu:20.04

# Build time arguments
ARG APP_ENV
ARG ENV_NAME
ARG PHP_VER
ENV APP_ENV=${ENV_NAME}

#Do not set this as env variable
#https://serverfault.com/questions/618994/when-building-from-dockerfile-debian-ubuntu-package-install-debconf-noninteract
ARG DEBIAN_FRONTEND=noninteractive

RUN  dpkg --add-architecture i386

RUN apt-get update && apt-get upgrade -y

#I: Install base requirements
RUN apt-get update &&\
    apt-get install --no-install-recommends --no-install-suggests -y \
        curl \
        wget \
        zip  \
        unzip  \
        openssh-client \
        locales \
        git \
        libc6:i386 \
        software-properties-common \
        libtool \
        libstdc++6:i386 \
        brotli  && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Most common PHP modules, and Composer
# First group of modules are enabled by default
# Second group must have their INI directories included via PHP_INI_SCAN_DIR
RUN set -eux ;\
    apt-get update &&\
    apt-get install --no-install-recommends --no-install-suggests -y \
        php${PHP_VER} \
        php${PHP_VER}-cli \
        php${PHP_VER}-redis \
        php${PHP_VER}-igbinary \
        php${PHP_VER}-curl \
        php${PHP_VER}-mbstring \
        php${PHP_VER}-mysql \
        php${PHP_VER}-uuid \
        php${PHP_VER}-common \
        php${PHP_VER}-xml \
        php${PHP_VER}-intl \
        php-fpm && \
    apt-get -y --purge autoremove &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/{man,doc}

COPY docker/php/${PHP_VER}/${ENV_NAME}-php.ini  /etc/php/${PHP_VER}/fpm/php.ini
COPY docker/php/${PHP_VER}/${ENV_NAME}-php_cli.ini /etc/php/${PHP_VER}/cli/php.ini
COPY docker/php/${PHP_VER}/${ENV_NAME}-zz-docker.conf /etc/php/${PHP_VER}/fpm/pool.d/zz-docker.conf

# Copy the composer phar
# COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Install Composer.
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm composer-setup.php

# Cleanup Remove docker config files from container
RUN rm -rf docker-configs || true
RUN rm -f .dockerignore || true

# Not sure why this is necessary?
RUN mkdir -p /run/php/

# Ssh prepwork (key is injected in prod, mounted in sandbox)
RUN mkdir -p /root/.ssh/
RUN echo "Host *" > /root/.ssh/config
RUN echo "StrictHostKeyChecking no" >> /root/.ssh/config
RUN echo "UserKnownHostsFile /dev/null" >> /root/.ssh/config
RUN echo "IdentityFile ~/.ssh/id_rsa" >> /root/.ssh/config

# Add user for laravel application.
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY ./site /var/www

# Copy existing application directory permissions.
RUN chown -R www:www /var/www

#RUN chown -R www:www-data /var/www/storage
#RUN chmod -R ug+wrx /var/www/storage

# Change current user to www
#USER www-data

# ======================

# FROM ${ENV_NAME}-${PROJECT_NAME}-phpfpmbase:latest

VOLUME /var/www/site

CMD ["php-fpm7.4"]