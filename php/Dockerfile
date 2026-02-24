FROM php:8.3-cli-alpine
RUN apk add --no-cache libstdc++ && \
    docker-php-ext-install pcntl posix
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /app
COPY composer.json ./
RUN composer install --no-dev --optimize-autoloader
COPY server.php ./
EXPOSE 8080
CMD ["php", "server.php", "start"]
