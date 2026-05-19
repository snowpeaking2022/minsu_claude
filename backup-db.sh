#!/bin/bash

# 水云阁民宿管理系统 - 数据库备份脚本
# 自动备份 MySQL 数据库并保存到指定目录

# 配置信息
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${PROJECT_DIR}/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/shuiyunge_db_${TIMESTAMP}.sql.gz"
LOG_FILE="${PROJECT_DIR}/logs/backup_${TIMESTAMP}.log"

# 数据库连接信息
DB_CONTAINER="shuiyunge-mysql"
DB_NAME="shuiyunge"
DB_USER="shuiyunge_user"
DB_PASSWORD="WaterCloud2026!"

# 创建备份目录和日志目录
mkdir -p "${BACKUP_DIR}"
mkdir -p "$(dirname "${LOG_FILE}")"

# 记录开始时间
echo "开始备份数据库... $(date)" > "${LOG_FILE}"
echo "备份文件: ${BACKUP_FILE}" >> "${LOG_FILE}"
echo "---------------------------" >> "${LOG_FILE}"

# 执行备份
echo "正在创建数据库备份..." >> "${LOG_FILE}"
docker exec -i "${DB_CONTAINER}" mysqldump -u"${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}" 2>>"${LOG_FILE}" | gzip > "${BACKUP_FILE}"

# 检查备份是否成功
if [ $? -eq 0 ]; then
    echo "数据库备份成功！" >> "${LOG_FILE}"
    echo "文件大小: $(du -h "${BACKUP_FILE}" | awk '{print $1}')" >> "${LOG_FILE}"

    # 保留最近 7 天的备份，删除旧备份
    echo "---------------------------" >> "${LOG_FILE}"
    echo "正在清理旧备份（保留最近7天）..." >> "${LOG_FILE}"
    find "${BACKUP_DIR}" -name "shuiyunge_db_*.sql.gz" -type f -mtime +7 -delete >> "${LOG_FILE}" 2>&1
    echo "备份清理完成！" >> "${LOG_FILE}"
else
    echo "数据库备份失败！" >> "${LOG_FILE}"
    echo "请检查 MySQL 容器是否正在运行，并检查日志文件: ${LOG_FILE}"
    exit 1
fi

# 记录结束时间
echo "---------------------------" >> "${LOG_FILE}"
echo "备份完成时间: $(date)" >> "${LOG_FILE}"

# 输出成功信息
echo "✅ 数据库备份成功！"
echo "备份文件: ${BACKUP_FILE}"
echo "日志文件: ${LOG_FILE}"

# 发送通知（可选）
# 如果需要发送邮件或 Slack 通知，可以在此添加相关代码

exit 0