# 快速部署指南

## 生产环境快速部署

### 系统要求
- Docker 24+
- Docker Compose 2+
- Linux (Ubuntu 22.04 recommended)
- 至少 2GB RAM

### 一键部署脚本
```bash
#!/bin/bash
# 快速部署脚本
set -e

# 项目配置
PROJECT_NAME="shuiyunge"
PROJECT_DIR="/opt/$PROJECT_NAME"
GIT_URL="<your-git-url>"
DOCKER_COMPOSE="/usr/bin/docker compose"

# 1. 系统准备
echo "系统准备..."
sudo apt-get update -qq >/dev/null
sudo apt-get install -qq -y docker.io docker-compose git curl ca-certificates lsb-release >/dev/null

# 2. 项目初始化
echo "项目初始化..."
sudo rm -rf $PROJECT_DIR
sudo git clone $GIT_URL $PROJECT_DIR
sudo chown -R $USER:$USER $PROJECT_DIR
cd $PROJECT_DIR

# 3. 配置环境变量
echo "配置环境变量..."
cp backend/.env.example backend/.env
# 生成 app key
$DOCKER_COMPOSE up -d php mysql
sleep 30
$DOCKER_COMPOSE exec -T php php artisan key:generate --force

# 4. 构建服务
echo "构建服务..."
$DOCKER_COMPOSE up -d --build

# 5. 数据库初始化
echo "数据库初始化..."
$DOCKER_COMPOSE exec -T php php artisan migrate --force
$DOCKER_COMPOSE exec -T php php artisan db:seed --force

# 6. 前端构建
echo "前端构建..."
cd $PROJECT_DIR/front
npm install && npm run generate
cd ..
$DOCKER_COMPOSE restart nginx

# 7. 验证部署
echo "部署完成!"
echo "请访问:"
echo "前端: http://localhost"
echo "phpMyAdmin: http://localhost:8080 (shuiyunge_user/WaterCloud2026!)"
echo "API: http://localhost/api/v1/rooms"
```

### 使用方法
1. 将脚本保存为 `quick-deploy.sh`
2. 赋予执行权限: `chmod +x quick-deploy.sh`
3. 运行脚本: `./quick-deploy.sh`

### 自动化部署（使用 GitHub Actions）
在 `.github/workflows/deploy.yml` 中添加:
```yaml
name: Deploy to Production
on: [push]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v4
    - name: Deploy
      uses: appleboy/ssh-action@v1
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USER }}
        key: ${{ secrets.SSH_KEY }}
        script: |
          cd /opt/shuiyunge
          git pull
          docker compose up -d --build
          docker compose exec -T php php artisan migrate --force
          cd front
          npm install && npm run generate
          docker compose restart nginx
```

### 环境变量说明
```bash
# 在 GitHub Secrets 中添加以下变量:
HOST=your-server-ip
USER=root
SSH_KEY=your-private-key
```

### 验证部署
部署完成后访问以下地址:
- 首页: `http://<server-ip>`
- API 测试: `curl -X GET http://<server-ip>/api/v1/rooms`
- phpMyAdmin: `http://<server-ip>:8080`
  - Username: shuiyunge_user
  - Password: WaterCloud2026!

### 维护命令
```bash
# 查看状态
cd /opt/shuiyunge
docker compose ps

# 查看日志
docker compose logs -f

# 重启服务
docker compose restart

# 数据库备份
docker compose exec -T mysql mysqldump -u shuiyunge_user -pWaterCloud2026! shuiyunge > db_backup.sql
```
