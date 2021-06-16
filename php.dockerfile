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

RUN set -eux; apt-get update; apt-get install -y libzip-dev zlib1g-dev procps lsof wget; docker-php-ext-install zip

#COPY /var/www/html/ioncube/ioncube_loader_lin_7.3.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/
#RUN cp /var/www/html/ioncube/ioncube_loader_lin_7.3.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/ioncube_loader_lin_7.3.so
RUN cd /tmp \ 
	&& curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.3.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/ioncube_loader_lin_7.3.so \
    && rm -Rf ioncube.tar.gz ioncube \