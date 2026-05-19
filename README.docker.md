# 水云阁民宿管理系统 - Docker 环境配置

## 环境要求
- Docker Desktop (Windows 10/11)
- Docker Compose

## 启动步骤

### 1. 启动 Docker Desktop
确保 Docker Desktop 已经启动。

### 2. 构建并启动容器
在项目根目录运行：
```bash
cd D:\workspace\testing
docker-compose up -d
```

### 3. 检查容器状态
```bash
docker-compose ps
```

### 4. 等待 MySQL 初始化完成
MySQL 第一次启动需要一些时间，等待约 30 秒。

### 5. 测试连接

**MySQL 连接：**
- 地址：localhost:3306
- 用户名：shuiyunge_user
- 密码：WaterCloud2026!
- 数据库：shuiyunge

**phpMyAdmin：**
- 访问地址：http://localhost:8080
- 用户名：shuiyunge_user
- 密码：WaterCloud2026!

## 初始化 Laravel 项目

### 1. 进入 PHP 容器
```bash
docker exec -it shuiyunge-php bash
cd /var/www/html
```

### 2. 创建 Laravel 项目
```bash
composer create-project laravel/laravel . --prefer-dist
```

### 3. 配置环境变量
```bash
cp .env.example .env
nano .env
```

修改以下配置：
```env
DB_DATABASE=shuiyunge
DB_USERNAME=shuiyunge_user
DB_PASSWORD=WaterCloud2026!
DB_HOST=mysql
DB_PORT=3306

APP_NAME=水云阁民宿
APP_URL=http://api.xiaohulu.cloud

SESSION_DOMAIN=xiaohulu.cloud
SANCTUM_STATEFUL_DOMAINS=xiaohulu.cloud,api.xiaohulu.cloud
```

### 4. 生成密钥和迁移
```bash
php artisan key:generate
php artisan migrate --seed
```

### 5. 安装 Sanctum
```bash
composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

## 访问应用

### 前台（Nuxt 3）
- 访问地址：http://localhost
- 开发模式：`cd front && npm run dev`

### 后台（Laravel API）
- 访问地址：http://localhost/api
- 健康检查：http://localhost/api/health

### 管理面板（phpMyAdmin）
- 访问地址：http://localhost:8080

## 常见问题

### 1. 容器无法启动
检查端口是否被占用：
```bash
netstat -ano | findstr :80
netstat -ano | findstr :3306
netstat -ano | findstr :8080
```

### 2. 无法访问 localhost
确保 Docker Desktop 的 Kubernetes 和 WSL 2 已配置正确。

### 3. MySQL 连接失败
- 等待容器初始化完成
- 检查 .env 中的配置
- 使用 `docker logs shuiyunge-mysql` 查看日志

## 开发建议

### 1. 代码修改
- 前端代码修改后，Nuxt 会自动热重载
- 后端代码修改后，需要重启 PHP 容器：
  ```bash
  docker restart shuiyunge-php
  ```

### 2. 数据库迁移
每次修改数据库结构后，运行：
```bash
docker exec -it shuiyunge-php bash
php artisan migrate
```

### 3. 查看日志
```bash
# 查看所有日志
docker-compose logs

# 查看特定服务日志
docker-compose logs php
docker-compose logs mysql
docker-compose logs nginx
```

## 停止和清理

### 停止容器
```bash
docker-compose stop
```

### 启动容器（不重建）
```bash
docker-compose start
```

### 停止并删除容器（保留数据）
```bash
docker-compose down
```

### 停止并删除容器和数据
```bash
docker-compose down -v
```

## 数据备份

### 备份数据库
```bash
docker exec -it shuiyunge-mysql mysqldump -u shuiyunge_user -pWaterCloud2026! shuiyunge > backup-$(date +%Y%m%d).sql
```

### 恢复数据库
```bash
docker exec -i shuiyunge-mysql mysql -u shuiyunge_user -pWaterCloud2026! shuiyunge < backup-file.sql
```
