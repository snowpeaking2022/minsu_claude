#!/bin/bash
# 水云阁民宿管理系统 - 部署前检查脚本
# 使用方法: ./pre-deploy-check.sh

set -e

# 项目配置
PROJECT_NAME="shuiyunge"
PROJECT_DIR=$(pwd)

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

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
}

# 检查根目录
if [ ! -f "docker-compose.prod.yml" ]; then
    log_error "请在项目根目录运行此脚本"
    exit 1
fi

log_info "=== 水云阁民宿管理系统 - 部署前检查 ==="

# 检查 1: 文件结构
log_info "1. 检查项目结构..."

required_dirs=(
    "backend"
    "front"
    "docker"
    "docker/nginx"
    "docker/php"
    "docker/mysql"
    "docker/redis"
)

required_files=(
    "docker-compose.prod.yml"
    "deploy-prod.sh"
    "backend/composer.json"
    "backend/package.json"
    "front/package.json"
    "docker/nginx/conf.d/app.conf"
    "docker/php/Dockerfile"
    "docker/mysql/init/01_create_user.sql"
)

for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        log_success "目录存在: $dir"
    else
        log_error "目录缺失: $dir"
        exit 1
    fi
done

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        log_success "文件存在: $file"
    else
        log_error "文件缺失: $file"
        exit 1
    fi
done

# 检查 2: 配置文件
log_info "2. 检查配置文件..."

if [ ! -f "backend/.env.example" ]; then
    log_error "backend/.env.example 文件缺失"
    exit 1
else
    log_success "backend/.env.example 文件存在"
fi

if [ ! -f "docker/nginx/conf.d/app.conf" ]; then
    log_error "Nginx 配置文件缺失"
    exit 1
else
    log_success "Nginx 配置文件存在"
fi

if [ ! -f "docker/php/php.ini" ]; then
    log_warning "PHP 配置文件缺失，将使用默认配置"
else
    log_success "PHP 配置文件存在"
fi

# 检查 3: Docker 配置
log_info "3. 检查 Docker 配置..."

if grep -q "mysql:" docker-compose.prod.yml; then
    log_success "MySQL 服务配置存在"
else
    log_error "MySQL 服务配置缺失"
    exit 1
fi

if grep -q "php:" docker-compose.prod.yml; then
    log_success "PHP 服务配置存在"
else
    log_error "PHP 服务配置缺失"
    exit 1
fi

if grep -q "nginx:" docker-compose.prod.yml; then
    log_success "Nginx 服务配置存在"
else
    log_error "Nginx 服务配置缺失"
    exit 1
fi

if grep -q "redis:" docker-compose.prod.yml; then
    log_success "Redis 服务配置存在"
else
    log_warning "Redis 服务配置缺失"
fi

# 检查 4: 部署脚本权限
log_info "4. 检查脚本权限..."

if [ -f "deploy-prod.sh" ]; then
    if [ -x "deploy-prod.sh" ]; then
        log_success "部署脚本权限正确"
    else
        log_warning "部署脚本没有执行权限，正在添加..."
        chmod +x deploy-prod.sh
    fi
else
    log_error "部署脚本缺失"
    exit 1
fi

if [ -f "rollback.sh" ]; then
    if [ -x "rollback.sh" ]; then
        log_success "回滚脚本权限正确"
    else
        log_warning "回滚脚本没有执行权限，正在添加..."
        chmod +x rollback.sh
    fi
else
    log_warning "回滚脚本缺失"
fi

# 检查 5: 前端依赖配置
log_info "5. 检查前端配置..."

if grep -q "nuxt" front/package.json; then
    log_success "Nuxt 依赖配置正确"
else
    log_warning "未找到 Nuxt 依赖"
fi

if grep -q "element-plus" front/package.json; then
    log_success "Element Plus 依赖正确"
else
    log_warning "未找到 Element Plus 依赖"
fi

if grep -q "generate" front/package.json; then
    log_success "生成命令配置正确"
else
    log_error "前端构建命令缺失"
    exit 1
fi

# 检查 6: 后端依赖配置
log_info "6. 检查后端配置..."

if grep -q "laravel" backend/composer.json; then
    log_success "Laravel 依赖配置正确"
else
    log_error "未找到 Laravel 依赖"
    exit 1
fi

if grep -q "sanctum" backend/composer.json; then
    log_success "Laravel Sanctum 依赖正确"
else
    log_warning "未找到 Laravel Sanctum 依赖"
fi

# 检查 7: Node.js 版本
log_info "7. 检查 Node.js 版本..."
if command -v node > /dev/null 2>&1; then
    NODE_VERSION=$(node -v)
    log_info "Node.js 版本: $NODE_VERSION"

    if node -e "process.exit(parseInt(process.versions.node.split('.')[0]) < 18 ? 1 : 0)"; then
        log_warning "建议使用 Node.js 18 或更高版本"
    else
        log_success "Node.js 版本符合要求"
    fi
else
    log_warning "Node.js 未安装"
fi

# 检查 8: 端口可用性
log_info "8. 检查常用端口可用性..."

for port in 80 443 3306 8080 6379; do
    if lsof -Pi :$port -sTCP:LISTEN -t > /dev/null 2>&1; then
        log_warning "端口 $port 正在被占用"
    else
        log_success "端口 $port 可用"
    fi
done

log_info "=== 检查完成 ==="
echo

log_success "所有检查通过，项目已准备好部署！"
log_info "部署步骤:"
echo "1. 确保 Docker 已安装并运行"
echo "2. 运行部署脚本: ./deploy-prod.sh"
echo "3. 或者使用 CI/CD 自动部署"
echo
log_warning "注意: 首次部署可能需要较长时间"
