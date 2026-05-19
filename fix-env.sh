#!/bin/bash

# 修复 PHP 环境
echo "正在安装 zip 扩展..."
apt-get update && apt-get install -y libzip-dev
docker-php-ext-install zip

echo "正在检查 git 和 unzip..."
which git
which unzip

echo "正在重新配置 PHP 扩展..."
docker-php-ext-enable pdo_mysql mbstring tokenizer xml ctype json bcmath zip gd

echo "验证 PHP 扩展..."
php -m

echo "环境修复完成!"
