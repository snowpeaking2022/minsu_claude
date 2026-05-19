# GitHub Actions 自动部署配置

## 概述

本项目支持通过 GitHub Actions 进行自动部署。当代码推送到 `master` 分支时，或手动触发部署时，会自动执行以下操作：

1. 检查代码是否符合要求
2. 构建 Docker 镜像（可选）
3. 备份当前服务器状态
4. 更新项目文件
5. 重新启动服务
6. 运行数据库迁移
7. 构建前端应用
8. 验证部署成功

## GitHub Secrets 配置

需要在 GitHub 仓库中配置以下 Secrets：

### 1. 服务器连接信息

#### 主机名
```
名称: SERVER_HOST
说明: 服务器 IP 地址或域名
示例: 192.168.1.100 或 example.com
```

#### 用户名
```
名称: SERVER_USER
说明: SSH 用户名（通常是 root）
示例: root
```

#### SSH 私钥
```
名称: SSH_PRIVATE_KEY
说明: 服务器的 SSH 私钥（用于连接服务器）
示例: -----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEA...
```

#### SSH 端口（可选）
```
名称: SSH_PORT
说明: SSH 连接端口（默认为 22）
示例: 22
```

### 2. Docker Hub 登录信息（可选，仅用于构建镜像）

#### Docker Hub 用户名
```
名称: DOCKER_USERNAME
说明: Docker Hub 用户名
示例: yourusername
```

#### Docker Hub 密码
```
名称: DOCKER_PASSWORD
说明: Docker Hub 密码或访问令牌
示例: yourpassword
```


## 工作流程文件说明

### 1. deploy.yml（完整流程）
- **触发条件**: 推送到 master 分支、手动触发
- **功能**: 
  - 检查代码
  - 构建 Docker 镜像
  - 部署到服务器
  - 运行迁移和优化
  - 备份和清理
- **适用场景**: 生产环境部署

### 2. deploy-simple.yml（简单流程）
- **触发条件**: 推送到 master 分支、手动触发
- **功能**: 
  - 复制文件到服务器
  - 使用 rsync 更新项目
  - 重新启动服务
  - 运行迁移
- **适用场景**: 测试环境部署或无 Docker Hub 访问权限

## 使用方法

### 1. 启用工作流程
- 确保 `./github/workflows/` 目录下有相应的工作流程文件
- 在 GitHub 仓库的 "Actions" 标签页中启用工作流程

### 2. 手动触发部署
- 转到 GitHub 仓库的 "Actions" 标签页
- 选择相应的工作流程
- 点击 "Run workflow" 按钮
- 配置选项（通常使用默认值）
- 点击 "Run workflow" 开始部署

### 3. 自动触发部署
- 代码推送到 `master` 分支时会自动触发
- 需要确保 Secrets 配置正确

## 部署流程说明

### 简单流程（deploy-simple.yml）
```
1. 检查代码
2. 复制文件到服务器
3. 备份当前状态
4. 更新项目文件
5. 重新启动服务
6. 运行数据库迁移
7. 构建前端应用
8. 验证部署
```

### 完整流程（deploy.yml）
```
1. 检查代码
2. 设置 Docker Buildx
3. 登录 Docker Hub
4. 构建并推送镜像
5. 部署到服务器
6. 运行数据库迁移
7. 优化 Laravel 应用
8. 构建前端
9. 清理旧备份
10. 通知 Slack
```

## 回滚操作

### 使用回滚脚本
```bash
# 从服务器运行
cd /opt/shuiyunge
./rollback.sh <备份文件名>

# 示例
./rollback.sh shuiyunge_backup_20260518_143000.tar.gz
```

### 手动回滚
```bash
# 停止当前服务
docker-compose -f docker-compose.prod.yml down

# 解压备份
tar -xzf /opt/shuiyunge_backups/shuiyunge_backup_*.tar.gz -C /opt/shuiyunge

# 启动服务
docker-compose -f docker-compose.prod.yml up -d
```

## 部署检查

### 运行检查脚本
```bash
# 从服务器运行
cd /opt/shuiyunge
./pre-deploy-check.sh
```

### 检查服务状态
```bash
docker-compose -f docker-compose.prod.yml ps
```

### 查看日志
```bash
# 查看所有日志
docker-compose -f docker-compose.prod.yml logs -f

# 查看特定服务日志
docker-compose -f docker-compose.prod.yml logs -f nginx
```

## 常见问题

### 1. 连接失败
- **原因**: 服务器不可达或端口被阻塞
- **解决**: 检查服务器网络和防火墙设置

### 2. 权限问题
- **原因**: SSH 密钥权限不正确或无写入权限
- **解决**: 检查服务器用户权限和密钥配置

### 3. 服务启动失败
- **原因**: 配置错误或资源耗尽
- **解决**: 检查日志和系统资源使用情况

### 4. 前端构建失败
- **原因**: Node.js 版本不兼容或依赖缺失
- **解决**: 检查 Node.js 版本和 npm 依赖安装

## 最佳实践

### 1. 使用预部署检查
- 在部署前运行 `./pre-deploy-check.sh` 确保项目准备就绪

### 2. 定期备份
- 部署过程会自动备份，但建议定期手动备份重要数据

### 3. 测试部署过程
- 使用测试环境验证部署脚本的正确性
- 手动触发部署进行测试

### 4. 监控和告警
- 配置监控系统及时发现问题
- 使用 Slack 通知获取部署状态更新

## 文件位置

- **工作流程文件**: `.github/workflows/deploy.yml` 和 `deploy-simple.yml`
- **部署脚本**: `deploy-prod.sh` 和 `rollback.sh`
- **检查脚本**: `pre-deploy-check.sh`
- **配置文件**: `docker-compose.prod.yml` 和各服务配置
