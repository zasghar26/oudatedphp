FROM php:7-apache

LABEL maintainer="Samuel ROZE <samuel.roze@example.com>"

RUN a2enmod rewrite \
    && echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
    && a2enconf servername

WORKDIR /var/www/html

# Copy composer files first
COPY composer.json composer.lock ./

# Install Composer
RUN apt-get update && apt-get install -y unzip git \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-interaction --no-progress --prefer-dist

# Copy the rest of your app
COPY ./web/ /var/www/html/

# Add a simple info.php file 
RUN echo "<?php phpinfo(); ?>" > /var/www/html/info.php

EXPOSE 80
CMD ["apache2-foreground"]

