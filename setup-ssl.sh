#!/bin/bash

# 水云阁民宿管理系统 - SSL 证书设置脚本
# 用于设置 HTTPS 连接

# 配置信息
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSL_DIR="${PROJECT_DIR}/docker/nginx/ssl"
DOMAIN=${1:-"localhost"}

# 创建 SSL 目录
mkdir -p "${SSL_DIR}"

# 检查是否已安装 OpenSSL
if ! command -v openssl &> /dev/null; then
    echo "❌ 错误: OpenSSL 未安装，请先安装 OpenSSL"
    exit 1
fi

echo "📝 正在为 ${DOMAIN} 生成自签名证书..."

# 生成私钥
openssl genrsa -out "${SSL_DIR}/privkey.pem" 2048 2>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ 错误: 私钥生成失败"
    exit 1
fi

# 生成证书签名请求 (CSR)
openssl req -new -key "${SSL_DIR}/privkey.pem" -out "${SSL_DIR}/csr.pem" -subj "/C=CN/ST=Beijing/L=Beijing/O=ShuiYunGe/OU=IT/CN=${DOMAIN}" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ 错误: CSR 生成失败"
    exit 1
fi

# 生成自签名证书（有效期 1 年）
openssl x509 -req -days 365 -in "${SSL_DIR}/csr.pem" -signkey "${SSL_DIR}/privkey.pem" -out "${SSL_DIR}/fullchain.pem" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ 错误: 证书生成失败"
    exit 1
fi

# 设置正确的权限
chmod 600 "${SSL_DIR}/privkey.pem"
chmod 644 "${SSL_DIR}/fullchain.pem"

# 清理 CSR 文件（不再需要）
rm -f "${SSL_DIR}/csr.pem"

echo "✅ SSL 证书生成成功！"
echo "📄 私钥文件: ${SSL_DIR}/privkey.pem"
echo "📄 证书文件: ${SSL_DIR}/fullchain.pem"
echo ""
echo "📝 提示: 在生产环境中，建议使用 Let's Encrypt 等证书颁发机构提供的免费证书"
echo "   Certbot 工具可以帮助您自动申请和续期证书"
echo ""
echo "🔄 重启 Nginx 以应用证书: docker-compose restart nginx"

exit 0