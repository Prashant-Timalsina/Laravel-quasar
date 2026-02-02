# Build stage
FROM php:8.2-fpm-alpine as builder

# Install system dependencies
RUN apk add --no-cache \
    curl \
    git \
    composer \
    npm \
    sqlite \
    sqlite-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    zlib-dev \
    libzip-dev \
    oniguruma-dev

# Install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_sqlite \
    mbstring \
    zip \
    bcmath \
    gd

# Set working directory
WORKDIR /app

# Copy composer files
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --no-dev --no-interaction --prefer-dist

# Copy application files
COPY . .

# Copy package files for frontend assets
COPY package.json package-lock.json* ./

# Install npm dependencies and build assets
RUN npm install && npm run build

# Generate Laravel key
RUN cp .env.example .env && \
    php artisan key:generate

# Production stage
FROM php:8.2-fpm-alpine

# Install runtime dependencies
RUN apk add --no-cache \
    sqlite \
    sqlite-lib \
    libpng \
    libjpeg-turbo \
    libwebp \
    zlib \
    libzip \
    oniguruma \
    nginx \
    supervisor

# Install PHP extensions
RUN docker-php-ext-configure gd --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_sqlite \
    mbstring \
    zip \
    bcmath \
    gd

# Set working directory
WORKDIR /app

# Copy from builder
COPY --from=builder /app /app
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d

# Create storage directories with proper permissions
RUN mkdir -p storage/logs storage/framework/cache storage/framework/sessions storage/framework/views && \
    chown -R www-data:www-data storage bootstrap/cache public && \
    chmod -R 755 storage bootstrap/cache

# Copy nginx configuration
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Copy PHP configuration
COPY docker/php.ini /usr/local/etc/php/conf.d/99-custom.ini

# Copy supervisor configuration
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose port
EXPOSE 8000

# Start supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
