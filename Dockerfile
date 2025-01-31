FROM drupal:11.1-apache

RUN apt-get update && apt-get install -y \
    libicu-dev \
    g++ \
    libzip-dev \
    git \
    zip \
    unzip \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl bcmath opcache \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/drupal

COPY ./drupal /opt/drupal

RUN chown -R www-data:www-data /opt/drupal \
    && chmod -R 755 /opt/drupal

RUN composer install --no-dev --optimize-autoloader --working-dir=/opt/drupal

RUN rm -rf /var/www/html && ln -s /opt/drupal/web /var/www/html

RUN a2enmod rewrite
