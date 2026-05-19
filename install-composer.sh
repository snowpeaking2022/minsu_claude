#!/bin/bash

# 安装 Composer 和 PHP 扩展
echo "正在更新包列表..."
apt-get update

echo "正在安装必要的依赖..."
apt-get install -y curl git unzip libssl-dev zlib1g-dev libzip-dev libpng-dev libjpeg-dev libfreetype6-dev

echo "正在安装 PHP 扩展..."
docker-php-ext-configure gd --with-freetype --with-jpeg
docker-php-ext-install pdo_mysql mbstring tokenizer xml ctype json bcmath zip gd openssl

echo "正在安装 Composer..."
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo "Composer 安装成功!"
composer --version

echo "环境配置完成!"
