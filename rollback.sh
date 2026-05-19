#!/bin/bash
# 水云阁民宿管理系统 - 回滚脚本
# 使用方法: ./rollback.sh <备份文件名>

set -e

# 项目配置
PROJECT_NAME="shuiyunge"
PROJECT_DIR="/opt/shuiyunge"
BACKUP_DIR="/opt/shuiyunge_backups"

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

# 检查参数
if [ $# -eq 0 ]; then
    log_error "使用方法: $0 <备份文件名>"
    log_info "可用备份文件:"
    ls -1 $BACKUP_DIR/shuiyunge_backup_*.tar.gz 2>/dev/null || log_warning "没有找到备份文件"
    exit 1
fi

BACKUP_FILE="$1"

# 检查备份文件
if [ ! -f "$BACKUP_FILE" ]; then
    # 尝试从备份目录查找
    if [ -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
        BACKUP_FILE="$BACKUP_DIR/$BACKUP_FILE"
    else
        log_error "备份文件不存在: $1"
        exit 1
    fi
fi

log_info "开始回滚到版本: $(basename $BACKUP_FILE)"

# 停止当前服务
log_info "停止当前服务..."
cd $PROJECT_DIR
docker-compose -f docker-compose.prod.yml down

# 创建临时目录
TEMP_DIR=$(mktemp -d)
log_info "创建临时目录: $TEMP_DIR"

# 解压备份
log_info "解压备份文件..."
tar -xzf $BACKUP_FILE -C $TEMP_DIR

# 备份当前状态（作为回滚前的最后状态）
LAST_STATE="$BACKUP_DIR/shuiyunge_last_state_$(date +%Y%m%d_%H%M%S).tar.gz"
log_info "备份当前状态到: $(basename $LAST_STATE)"
tar -czf $LAST_STATE -C $PROJECT_DIR . 2>/dev/null || log_warning "无法备份当前状态"

# 恢复备份
log_info "恢复备份..."
rsync -av --delete \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='vendor' \
    --exclude='.env' \
    --exclude='docker/nginx/ssl' \
    --exclude='storage' \
    $TEMP_DIR/ $PROJECT_DIR/

# 清理临时目录
rm -rf $TEMP_DIR

# 重新启动服务
log_info "重新启动服务..."
cd $PROJECT_DIR
docker-compose -f docker-compose.prod.yml up -d

# 等待服务启动
log_info "等待服务启动..."
sleep 30

# 检查服务状态
log_info "检查服务状态..."
if docker-compose -f docker-compose.prod.yml ps | grep -q "Up"; then
    log_info "服务已成功启动"
else
    log_error "部分服务未能启动"
    docker-compose -f docker-compose.prod.yml ps
    exit 1
fi

# 检查应用可访问性
log_info "检查应用可访问性..."

# 检查前端
if curl -s http://localhost > /dev/null; then
    log_info "前端访问正常"
else
    log_error "前端访问失败"
fi

# 检查 API
if curl -s http://localhost/api/v1/health > /dev/null; then
    log_info "API 访问正常"
else
    log_error "API 访问失败"
fi

log_info "回滚完成！"
echo
log_info "回滚详情:"
echo "  备份文件: $(basename $BACKUP_FILE)"
echo "  回滚时间: $(date)"
echo "  前一状态备份: $(basename $LAST_STATE)"
echo
log_info "管理命令:"
echo "  查看状态: docker compose -f docker-compose.prod.yml ps"
echo "  查看日志: docker compose -f docker-compose.prod.yml logs -f"
echo "  重启服务: docker compose -f docker-compose.prod.yml restart"
