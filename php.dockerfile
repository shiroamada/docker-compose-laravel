FROM php:7.3-fpm-buster

ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN set -x \
# create nginx user/group first, to be consistent throughout docker variants
    && addgroup --system --gid 101 laravel \
    && adduser --system --disabled-login --ingroup laravel --no-create-home --home /nonexistent --gecos "laravel user" --shell /bin/false --uid 101 laravel

RUN mkdir -p /var/www/html

RUN chown laravel:laravel /var/www/html

WORKDIR /var/www/html

RUN pecl install xdebug-2.9.2 \
    && docker-php-ext-enable xdebug  \
    && docker-php-ext-install pdo pdo_mysql mysqli \
    && docker-php-ext-enable mysqli 

RUN apt-get update && \
apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev && \
docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
docker-php-ext-install gd