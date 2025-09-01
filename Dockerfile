FROM php:8.2-fpm-alpine AS builder

# Install all dependencies and PHP extensions
RUN apk add --no-cache \
    git \
    build-base \
    libpng-dev \
    libjpeg-turbo-dev \
    libxml2-dev \
    autoconf \
    curl \
    on-build \
    on-dev

WORKDIR /app

COPY . /app

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader
RUN vendor/bin/phpunit


# Final Stage (Production Image)
FROM php:8.2-fpm-alpine AS final

# Install only the packages required by the app
RUN apk add --no-cache \
    libpng \
    libjpeg-turbo \
    libxml2

WORKDIR /var/www/html

COPY --from=builder /app /var/www/html
RUN chown -R www-data:www-data /var/www/html/storage \
    && chown -R www-data:www-data /var/www/html/bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]
