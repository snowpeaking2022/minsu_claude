FROM php:8.2-fpm

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    libzip-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 安装PHP扩展
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# 设置工作目录
WORKDIR /var/www/html

# 复制现有应用
COPY --chown=www-data:www-data . /var/www/html

# 启动php-fpm服务
CMD ["php-fpm"]