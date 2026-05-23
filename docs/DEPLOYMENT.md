# 水云阁民宿网站部署文档

## 目录

1. [概述](#概述)
2. [服务器要求](#服务器要求)
3. [部署前准备](#部署前准备)
4. [部署步骤](#部署步骤)
5. [SSL证书配置](#ssl证书配置)
6. [配置文件说明](#配置文件说明)
7. [备份与恢复](#备份与恢复)
8. [更新部署](#更新部署)
9. [常见问题](#常见问题)

---

## 概述

本文档描述如何将水云阁民宿网站部署到生产服务器。该项目使用 Docker Compose 进行容器化部署，包含以下服务：

- **PHP 8.2** - Laravel 后端应用
- **Nginx** - Web 服务器和反向代理
- **MySQL 8.0** - 主数据库
- **Redis** - 缓存和会话存储

---

## 服务器要求

### 最低配置

- CPU: 2 核
- 内存: 2 GB
- 磁盘: 20 GB SSD
- 操作系统: Ubuntu 20.04+ / Debian 11+ / CentOS 8+

### 推荐配置

- CPU: 4 核
- 内存: 4 GB+
- 磁盘: 50 GB+ SSD
- 操作系统: Ubuntu 22.04 LTS

### 软件要求

- Docker 20.10+
- Docker Compose 2.0+
- Git
- OpenSSL (用于生成自签名证书或申请 Let's Encrypt)

---

## 部署前准备

### 1. 服务器环境初始化

```bash
# 更新系统包
sudo apt update && sudo apt upgrade -y

# 安装必要工具
sudo apt install -y git curl vim wget

# 安装 Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 将当前用户添加到 docker 组
sudo usermod -aG docker $USER

# 重新登录或执行以下命令使组设置生效
newgrp docker

# 安装 Docker Compose
sudo apt install -y docker-compose-plugin

# 验证安装
docker --version
docker compose version
```

### 2. 域名解析

将您的域名（例如 `shuiyunge.com`）解析到服务器的公网 IP 地址：

- A 记录: `shuiyunge.com` → 服务器 IP
- A 记录: `www.shuiyunge.com` → 服务器 IP

### 3. 准备配置文件

```bash
# 克隆项目代码
cd /opt
sudo git clone https://github.com/snowpeaking2022/minsu_claude.git shuiyunge
cd shuiyunge

# 复制环境变量模板
cp backend/.env.example backend/.env

# 编辑环境变量（重要！）
vim backend/.env
```

需要修改的关键配置项：

```env
APP_NAME="水云阁民宿"
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-domain.com

# 数据库配置
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=shuiyunge
DB_USERNAME=shuiyunge_user
DB_PASSWORD=请设置强密码

# Redis 配置
REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379

# 文件存储
FILESYSTEM_DISK=public
```

---

## 部署步骤

### 步骤 1: 创建项目目录

```bash
cd /opt
sudo mkdir -p shuiyunge
sudo chown $USER:$USER shuiyunge
cd shuiyunge
```

### 步骤 2: 获取项目代码

```bash
git clone https://github.com/snowpeaking2022/minsu_claude.git .
```

### 步骤 3: 配置环境变量

```bash
cd backend
cp .env.example .env

# 生成应用密钥
# 注意：先不启动，后面步骤统一操作
```

### 步骤 4: 准备 SSL 证书目录

```bash
cd /opt/shuiyunge
mkdir -p docker/nginx/ssl
```

### 步骤 5: 使用生产环境配置启动

```bash
# 复制生产环境配置模板（如果需要）
cp docker-compose.prod.yml docker-compose.yml

# 配置环境变量
cat > .env << 'EOF'
DB_ROOT_PASSWORD=请设置强密码
DB_PASSWORD=请设置数据库用户密码
EOF

# 构建并启动服务
docker compose -f docker-compose.prod.yml up -d --build
```

### 步骤 6: 初始化 Laravel 应用

```bash
# 进入 PHP 容器
docker compose -f docker-compose.prod.yml exec php bash

# 在容器内执行以下命令
cd /var/www/backend

# 安装依赖（如果还没安装）
composer install --no-dev --optimize-autoloader

# 生成应用密钥
php artisan key:generate

# 运行数据库迁移
php artisan migrate --force

# 填充初始数据（可选）
php artisan db:seed --class=UserSeeder

# 生成存储链接
php artisan storage:link

# 优化配置缓存
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 设置目录权限
chown -R www-data:www-data /var/www/backend/storage /var/www/backend/bootstrap/cache
chmod -R 775 /var/www/backend/storage /var/www/backend/bootstrap/cache

# 退出容器
exit
```

### 步骤 7: 配置 Nginx（根据需要修改）

Nginx 配置文件位于: `docker/nginx/conf.d/app.conf`

主要配置项：
- 域名: 将 `localhost` 替换为您的实际域名
- SSL 证书路径: 确认证书文件路径正确

---

## SSL证书配置

### 选项 A: 使用 Let's Encrypt 免费证书（推荐）

```bash
# 安装 certbot
sudo apt install -y certbot

# 停止 Nginx 以释放 80 端口
cd /opt/shuiyunge
docker compose -f docker-compose.prod.yml stop nginx

# 获取证书（交互式）
sudo certbot certonly --standalone -d your-domain.com -d www.your-domain.com

# 复制证书到项目目录
sudo cp /etc/letsencrypt/live/your-domain.com/fullchain.pem docker/nginx/ssl/cert.pem
sudo cp /etc/letsencrypt/live/your-domain.com/privkey.pem docker/nginx/ssl/key.pem

# 设置权限
sudo chmod 644 docker/nginx/ssl/cert.pem
sudo chmod 600 docker/nginx/ssl/key.pem

# 重启服务
docker compose -f docker-compose.prod.yml up -d
```

#### 自动续期

```bash
# 创建续期脚本
sudo tee /etc/letsencrypt/renewal-hooks/deploy/shuiyunge.sh << 'EOF'
#!/bin/bash
cp /etc/letsencrypt/live/your-domain.com/fullchain.pem /opt/shuiyunge/docker/nginx/ssl/cert.pem
cp /etc/letsencrypt/live/your-domain.com/privkey.pem /opt/shuiyunge/docker/nginx/ssl/key.pem
chmod 644 /opt/shuiyunge/docker/nginx/ssl/cert.pem
chmod 600 /opt/shuiyunge/docker/nginx/ssl/key.pem
cd /opt/shuiyunge
docker compose -f docker-compose.prod.yml restart nginx
EOF

sudo chmod +x /etc/letsencrypt/renewal-hooks/deploy/shuiyunge.sh

# 测试续期
sudo certbot renew --dry-run
```

### 选项 B: 使用自签名证书（仅用于测试）

```bash
cd /opt/shuiyunge/docker/nginx/ssl

# 生成自签名证书
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout key.pem \
  -out cert.pem \
  -subj "/C=CN/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"

chmod 644 cert.pem
chmod 600 key.pem
```

---

## 配置文件说明

### 1. docker-compose.prod.yml

生产环境 Docker Compose 配置，包含服务资源限制。

### 2. backend/.env

Laravel 环境配置文件，重要设置：

- `APP_ENV=production` - 生产环境模式
- `APP_DEBUG=false` - 关闭调试模式
- `APP_URL=https://your-domain.com` - 应用 URL

### 3. docker/nginx/conf.d/app.conf

Nginx 虚拟主机配置，包含：
- PHP 后端路由 (/admin, /api)
- 前端 SPA 路由
- 文件上传大小限制 (max 20M)
- SSL 配置

---

## 备份与恢复

### 数据库备份

```bash
# 创建备份脚本
cat > /opt/shuiyunge/scripts/backup-db.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/opt/shuiyunge/backups"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

docker compose -f /opt/shuiyunge/docker-compose.prod.yml exec -T mysql \
  mysqldump -u shuiyunge_user -p$(grep DB_PASSWORD /opt/shuiyunge/backend/.env | cut -d '=' -f 2) shuiyunge \
  | gzip > $BACKUP_DIR/shuiyunge_db_$DATE.sql.gz

# 保留最近 30 天的备份
find $BACKUP_DIR -name "shuiyunge_db_*.sql.gz" -mtime +30 -delete
EOF

chmod +x /opt/shuiyunge/scripts/backup-db.sh

# 添加到 crontab（每天凌晨 2 点执行）
crontab -e
# 添加行: 0 2 * * * /opt/shuiyunge/scripts/backup-db.sh
```

### 文件备份

```bash
# 备份 storage 目录
tar -czf /opt/shuiyunge/backups/storage_$(date +%Y%m%d).tar.gz \
  -C /opt/shuiyunge/backend storage/app/public
```

### 恢复数据库

```bash
# 解压备份
gunzip /opt/shuiyunge/backups/shuiyunge_db_20260523_020000.sql.gz

# 恢复
docker compose -f /opt/shuiyunge/docker-compose.prod.yml exec -T mysql \
  mysql -u shuiyunge_user -p$(grep DB_PASSWORD /opt/shuiyunge/backend/.env | cut -d '=' -f 2) shuiyunge \
  < /opt/shuiyunge/backups/shuiyunge_db_20260523_020000.sql
```

---

## 更新部署

### 更新代码并重新部署

```bash
cd /opt/shuiyunge

# 拉取最新代码
git pull origin master

# 如果有数据库迁移，先备份
./scripts/backup-db.sh

# 重新构建并启动服务
docker compose -f docker-compose.prod.yml up -d --build

# 进入 PHP 容器执行更新
docker compose -f docker-compose.prod.yml exec php bash
cd /var/www/backend

# 更新依赖
composer install --no-dev --optimize-autoloader

# 运行迁移
php artisan migrate --force

# 清除并重新缓存
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 设置权限
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

exit

# 重启服务（如需要）
docker compose -f docker-compose.prod.yml restart
```

### 快速回滚

```bash
# 如果更新出现问题，回滚到上一个版本
git reset --hard HEAD~1
docker compose -f docker-compose.prod.yml up -d --build
# 然后恢复数据库备份（如需要）
```

---

## 常见问题

### 1. 容器无法启动

```bash
# 查看日志
docker compose -f docker-compose.prod.yml logs php
docker compose -f docker-compose.prod.yml logs nginx
docker compose -f docker-compose.prod.yml logs mysql

# 检查端口占用
sudo netstat -tlnp | grep -E ':(80|443|3306)'
```

### 2. 权限问题

```bash
# 确保 storage 和 bootstrap/cache 目录可写
docker compose -f docker-compose.prod.yml exec php chown -R www-data:www-data /var/www/backend/storage /var/www/backend/bootstrap/cache
docker compose -f docker-compose.prod.yml exec php chmod -R 775 /var/www/backend/storage /var/www/backend/bootstrap/cache
```

### 3. 数据库连接失败

```bash
# 确认 mysql 容器正在运行
docker compose -f docker-compose.prod.yml ps

# 检查 .env 中的 DB_HOST 是否设置为 "mysql"（服务名）

# 手动测试连接
docker compose -f docker-compose.prod.yml exec php mysql -h mysql -u shuiyunge_user -p shuiyunge
```

### 4. 500 错误但日志为空

```bash
# 检查 PHP-FPM 日志
docker compose -f docker-compose.prod.yml logs php

# 确保 APP_DEBUG=false 在生产环境
# 确保 storage/logs 目录可写
```

### 5. 上传文件大小限制

Nginx 配置中已设置 `client_max_body_size 20M;`，同时需要检查 PHP 的 `upload_max_filesize` 和 `post_max_size`（在 docker/php/php.ini）。

---

## 维护检查清单

### 每日检查

- [ ] 网站可正常访问
- [ ] 数据库备份正常运行
- [ ] 磁盘空间充足

### 每周检查

- [ ] 系统安全更新
- [ ] 应用日志检查
- [ ] SSL 证书有效期

### 每月检查

- [ ] 整体性能评估
- [ ] 备份完整性测试
- [ ] 依赖包安全更新

---

## 技术支持

如遇到部署问题，请：

1. 查看容器日志: `docker compose -f docker-compose.prod.yml logs`
2. 查看 Laravel 日志: `backend/storage/logs/laravel.log`
3. 提交 Issue 到 GitHub 项目仓库
