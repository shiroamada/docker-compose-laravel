FROM php:5.6-fpm

ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN set -x \
# create nginx user/group first, to be consistent throughout docker variants
    && addgroup --system --gid 101 laravel \
    && adduser --system --disabled-login --ingroup laravel --no-create-home --home /nonexistent --gecos "laravel user" --shell /bin/false --uid 101 laravel

RUN mkdir -p /var/www/html

RUN chown laravel:laravel /var/www/html

WORKDIR /var/www/html

# Fix for archived Debian repositories (PHP 5.6 uses old Debian Jessie)
RUN sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list && \
    sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list

# Install dependencies and PHP extensions
RUN apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true && \
    apt-get install -y --allow-unauthenticated libmcrypt-dev libzip-dev zlib1g-dev procps lsof wget && \
    docker-php-ext-install mcrypt pdo pdo_mysql mysqli zip && \
    docker-php-ext-enable mysqli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*