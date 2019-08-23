FROM php:7-apache
MAINTAINER KarinP <atelierkarin@gmail.com>

# Basic
WORKDIR /var/www/html
RUN cp -f /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime

# Enable Apache Rewrite
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2dismod -f autoindex

# Install Extensions
RUN apt-get update
RUN apt-get -y install \
        g++ \
        git \
        libicu-dev \
        libmcrypt-dev \
        libfreetype6-dev \
        libldap2-dev \
        libjpeg-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
        default-mysql-client \
        openssh-client \
        libxml2-dev \
        libsodium-dev \
        libzip-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-install iconv pdo pdo_mysql mbstring soap gd zip ldap bcmath sodium opcache

RUN apt-get install -y libgmp-dev
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/
RUN docker-php-ext-configure gmp
RUN docker-php-ext-install gmp

RUN apt-get install -y libssl-dev && \
    pecl install mongodb && \
    echo 'extension=mongodb.so' > /usr/local/etc/php/conf.d/20-mongodb.ini

RUN pecl install --force mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt

# Copy files and set permissions
COPY php.ini /usr/local/etc/php/php.ini

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin
