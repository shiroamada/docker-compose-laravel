FROM php:5.6-fpm

ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN set -x \
# create nginx user/group first, to be consistent throughout docker variants
    && addgroup --system --gid 101 laravel \
    && adduser --system --disabled-login --ingroup laravel --no-create-home --home /nonexistent --gecos "laravel user" --shell /bin/false --uid 101 laravel

RUN mkdir -p /var/www/html

RUN chown laravel:laravel /var/www/html

WORKDIR /var/www/html

RUN apt-get update && \
apt-get install -y libmcrypt-dev

# RUN pecl install mcrypt-1.0.4

RUN docker-php-ext-configure mcrypt \
    && docker-php-ext-install mcrypt

RUN docker-php-ext-install pdo pdo_mysql mysqli \
    && docker-php-ext-enable mysqli \
    && docker-php-ext-enable mcrypt

RUN apt-get update && \
apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev && \
docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
docker-php-ext-install gd 

RUN apt-get install -y libzip-dev \
&& docker-php-ext-install zip 