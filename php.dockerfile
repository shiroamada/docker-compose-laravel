FROM php:5.6-fpm

ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN set -x \
# create nginx user/group first, to be consistent throughout docker variants
    && addgroup --system --gid 101 laravel \
    && adduser --system --disabled-login --ingroup laravel --no-create-home --home /nonexistent --gecos "laravel user" --shell /bin/false --uid 101 laravel

RUN mkdir -p /var/www/html

RUN chown laravel:laravel /var/www/html

WORKDIR /var/www/html

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y libmcrypt-dev 

RUN docker-php-ext-install mcrypt

RUN docker-php-ext-install pdo pdo_mysql mysqli \
    && docker-php-ext-enable mysqli 

RUN set -eux; apt-get update; apt-get install -y libzip-dev zlib1g-dev procps lsof wget; docker-php-ext-install zip