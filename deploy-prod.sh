#!/bin/bash
# 水云阁民宿管理系统 - 生产环境部署脚本
# 使用方法: ./deploy-prod.sh

set -e  # 遇到错误立即停止

# 项目配置
PROJECT_NAME="shuiyunge"
PROJECT_DIR=$(pwd)
DOCKER_COMPOSE="docker compose"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查根目录
if [ ! -f "docker-compose.prod.yml" ]; then
    log_error "请在项目根目录运行此脚本"
    exit 1
fi

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    log_error "Docker 未运行，请先启动 Docker"
    exit 1
fi

# 1. 创建必要的目录
log_info "创建必要的目录..."
mkdir -p docker/nginx/ssl  # SSL 证书目录
mkdir -p docker/nginx/logs
mkdir -p docker/mysql/conf.d
mkdir -p docker/redis

# 2. 检查并配置环境变量
log_info "配置环境变量..."
if [ ! -f "backend/.env" ]; then
    log_warning "未找到 .env 文件，正在从 .env.example 创建..."
    cp backend/.env.example backend/.env
    log_info "请编辑 backend/.env 文件，配置生产环境参数"
    log_info "重要参数: APP_KEY, DB_PASSWORD, 等"
fi

# 3. 构建并启动服务
log_info "构建并启动生产环境服务..."
$DOCKER_COMPOSE -f docker-compose.prod.yml up -d --build

# 4. 等待服务启动
log_info "等待服务启动..."
sleep 30

# 5. 初始化数据库
log_info "初始化数据库..."
$DOCKER_COMPOSE -f docker-compose.prod.yml exec -T php php artisan migrate --force

# 检查是否需要填充数据
read -p "是否需要填充测试数据? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    $DOCKER_COMPOSE -f docker-compose.prod.yml exec -T php php artisan db:seed --force
    log_info "测试数据填充完成"
else
    log_info "跳过数据填充"
fi

# 6. 优化应用
log_info "优化 Laravel 应用..."
$DOCKER_COMPOSE -f docker-compose.prod.yml exec -T php php artisan config:cache
$DOCKER_COMPOSE -f docker-compose.prod.yml exec -T php php artisan route:cache
$DOCKER_COMPOSE -f docker-compose.prod.yml exec -T php php artisan view:cache
$DOCKER_COMPOSE -f docker-compose.prod.yml exec -T php php artisan optimize:clear

# 7. 构建前端
log_info "构建前端应用..."
cd front
if [ ! -d "node_modules" ]; then
    log_info "安装前端依赖..."
    npm install --production
fi

log_info "构建生产环境前端..."
npm run generate

cd ..

# 8. 重启 Nginx
log_info "重启 Nginx 服务..."
$DOCKER_COMPOSE -f docker-compose.prod.yml restart nginx

# 9. 验证部署
log_info "验证部署..."

# 检查前端是否可访问
if curl -s http://localhost > /dev/null; then
    log_info "前端访问正常"
else
    log_error "前端访问失败"
    exit 1
fi

# 检查 API 是否可访问
if curl -s http://localhost/api/v1/health > /dev/null; then
    log_info "API 访问正常"
else
    log_error "API 访问失败"
    exit 1
fi

log_info "部署完成!"
echo
log_info "访问地址:"
echo "  前端: http://localhost"
echo "  API: http://localhost/api/v1"
echo
log_info "管理命令:"
echo "  查看服务状态: docker compose -f docker-compose.prod.yml ps"
echo "  查看日志: docker compose -f docker-compose.prod.yml logs -f"
echo "  重启服务: docker compose -f docker-compose.prod.yml restart"
echo "  停止服务: docker compose -f docker-compose.prod.yml down"
