# 水云阁民宿管理系统 - 自动化部署指南

## 目录
- [环境要求](#环境要求)
- [本地开发环境部署](#本地开发环境部署)
- [生产环境部署](#生产环境部署)
- [CI/CD 流程](#cicd-流程)
- [维护与监控](#维护与监控)

---

## 环境要求

### 本地开发环境
- Docker & Docker Compose
- Node.js >= 20
- npm 或 yarn
- Git

### 生产环境
- Linux 服务器 (Ubuntu 22.04 推荐)
- Docker & Docker Compose
- 反向代理 (可选，如 Nginx)
- SSL 证书 (可选，推荐)

---

## 本地开发环境部署

### 1. 克隆项目
```bash
git clone <repository-url>
cd testing
```

### 2. 启动服务
```bash
# 启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps
```

### 3. 初始化数据库
```bash
# 运行数据库迁移
docker-compose exec php php artisan migrate --force

# 填充测试数据
docker-compose exec php php artisan db:seed --force
```

### 4. 前端构建
```bash
cd front
npm install
npm run generate
```

### 5. 访问应用
- 前端: http://localhost
- API: http://localhost/api/v1
- phpMyAdmin: http://localhost:8080 (用户: shuiyunge_user, 密码: WaterCloud2026!)

---

## 生产环境部署

### 1. 服务器准备

#### 安装 Docker
```bash
# 更新包索引
sudo apt-get update

# 安装必要依赖
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# 添加 Docker 官方 GPG 密钥
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 设置 Docker 仓库
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装 Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 验证安装
sudo docker --version
sudo docker-compose --version
```

#### 配置 Docker
```bash
# 将当前用户添加到 docker 组（避免每次使用 sudo）
sudo usermod -aG docker $USER

# 重新登录以应用更改
exit
```

### 2. 部署应用

#### 方法一：从 Git 仓库部署
```bash
# 在服务器上克隆代码
git clone <repository-url> /opt/shuiyunge
cd /opt/shuiyunge

# 启动服务
docker-compose up -d --build

# 初始化数据库
docker-compose exec php php artisan migrate --force
docker-compose exec php php artisan db:seed --force
```

#### 方法二：使用部署脚本
```bash
#!/bin/bash
# deploy.sh

set -e

# 项目目录
PROJECT_DIR="/opt/shuiyunge"
BACKUP_DIR="/opt/shuiyunge_backups"

# 1. 创建备份
mkdir -p $BACKUP_DIR
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
echo "备份当前版本..."
if [ -d "$PROJECT_DIR" ]; then
    tar -czf $BACKUP_DIR/shuiyunge_backup_$TIMESTAMP.tar.gz -C $(dirname $PROJECT_DIR) $(basename $PROJECT_DIR)
fi

# 2. 拉取最新代码
cd $PROJECT_DIR || git clone <repository-url> $PROJECT_DIR
cd $PROJECT_DIR
git pull origin master

# 3. 停止并重建容器
echo "重建服务..."
docker-compose down
docker-compose up -d --build

# 4. 运行数据库迁移
echo "运行数据库迁移..."
docker-compose exec php php artisan migrate --force

# 5. 构建前端
echo "构建前端..."
cd $PROJECT_DIR/front
npm install
npm run generate

# 6. 重启 nginx
echo "重启 nginx..."
docker-compose restart nginx

echo "部署完成!"
```

### 3. 配置环境变量

#### 修改 backend/.env
```env
APP_NAME=水云阁民宿
APP_ENV=production
APP_KEY=base64:your-generated-key-here
APP_DEBUG=false
APP_URL=https://yourdomain.com

LOG_CHANNEL=stack
LOG_STACK=single
LOG_LEVEL=error

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=shuiyunge
DB_USERNAME=shuiyunge_user
DB_PASSWORD=your-secure-password-here

BROADCAST_DRIVER=log
CACHE_DRIVER=redis
FILESYSTEM_DISK=local
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis
SESSION_DOMAIN=yourdomain.com

REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379
```

### 4. 配置 SSL (可选，推荐)
创建 nginx 配置文件 `docker/nginx/conf.d/ssl.conf`:
```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;
    root /var/www/front/.output/public;
    index index.html;

    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers off;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME /var/www/backend/public/index.php;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        include fastcgi_params;
    }

    location /admin {
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME /var/www/backend/public/index.php;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        include fastcgi_params;
    }
}

server {
    listen 80;
    server_name yourdomain.com;
    return 301 https://$server_name$request_uri;
}
```

更新 docker-compose.yml 来挂载 SSL证书:
```yaml
volumes:
  - ./docker/nginx/ssl:/etc/nginx/ssl:ro
```

---

## CI/CD 流程

### GitHub Actions 配置

在项目根目录创建 `.github/workflows/deploy.yml`:
```yaml
name: Deploy to Production
on:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
      
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '20'
        
    - name: Build front-end
      run: |
        cd front
        npm install
        npm run generate
        
    - name: Prepare archive
      run: |
        mkdir -p deploy
        tar -czf deploy/build.tar.gz \
          docker-compose.yml \
          docker/ \
          backend/ \
          front/.output/ \
          --exclude='node_modules' \
          --exclude='.git'

    - name: Deploy to server
      uses: appleboy/ssh-action@v1.0.3
      with:
        host: ${{ secrets.SERVER_HOST }}
        username: ${{ secrets.SERVER_USER }}
        key: ${{ secrets.SSH_PRIVATE_KEY }}
        port: 22
        script: |
          cd /opt/shuiyunge
          # Backup
          TIMESTAMP=$(date +%Y%m%d_%H%M%S)
          sudo tar -czf /opt/shuiyunge_backups/shuiyunge_$TIMESTAMP.tar.gz .
          # Pull
          git pull origin master
          # Restart services
          docker-compose down
          docker-compose up -d --build
          # Migrate
          docker-compose exec -T php php artisan migrate --force
          # Rebuild front-end (if needed)
          cd front && npm install && npm run generate
          docker-compose restart nginx
          # Verify deployment
          echo "Deployment completed successfully!"
```

### 设置 GitHub Secrets
在 GitHub 仓库设置中添加以下 Secrets:
- `SERVER_HOST`: 服务器地址
- `SERVER_USER`: 服务器用户名
- `SSH_PRIVATE_KEY`: SSH 私钥

---

## 维护与监控

### 查看日志
```bash
# 查看所有容器日志
docker-compose logs -f

# 查看单个容器日志
docker-compose logs -f nginx
docker-compose logs -f php
docker-compose logs -f mysql
```

### 数据库备份
```bash
# 备份数据库
docker-compose exec mysql mysqldump -u shuiyunge_user -pWaterCloud2026! shuiyunge > backup_$(date +%Y%m%d).sql

# 自动备份脚本
#!/bin/bash
BACKUP_DIR="/opt/shuiyunge/db_backups"
mkdir -p $BACKUP_DIR
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
docker-compose exec -T mysql mysqldump -u shuiyunge_user -pWaterCloud2026! shuiyunge | gzip > $BACKUP_DIR/shuiyunge_db_$TIMESTAMP.sql.gz

# 保留最近 30 天的备份
find $BACKUP_DIR -name "*.sql.gz" -type f -mtime +30 -delete
```

### 性能监控
- 使用 `docker stats` 监控容器资源使用
- 在 production 中考虑使用监控工具 (如 Prometheus + Grafana)
- 配置日志轮转 (logrotate)

---

## 故障排除

### 容器无法启动
```bash
# 检查日志
docker-compose logs

# 重新构建容器
docker-compose up -d --build
```

### 数据库连接失败
```bash
# 检查 mysql 容器状态
docker-compose ps

# 尝试连接到 mysql
docker-compose exec mysql mysql -u shuiyunge_user -pWaterCloud2026! shuiyunge
```

### 前端静态文件 404
```bash
# 确认前端已构建
ls -la front/.output/public/

# 检查 nginx 日志
docker-compose logs nginx
```

---

## 安全建议

1. **强密码**: 使用强密码并定期更换
2. **环境变量**: 不要将 .env 文件提交到 Git
3. **防火墙**: 只开放必要的端口 (80,443)
4. **更新**: 定期更新 Docker 镜像和依赖包
5. **备份**: 自动备份数据库和重要文件
6. **SSL**: 在生产环境中使用 HTTPS
