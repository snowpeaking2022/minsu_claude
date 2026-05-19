# 水云阁民宿管理系统

## 项目介绍

水云阁民宿管理系统是一个基于 Docker 容器化部署的全栈应用，旨在提供便捷的酒店管理功能。系统采用前后端分离架构，前端使用 Nuxt 3 + Vue 3 + Element Plus，后端使用 Laravel 11 + MySQL 8.0 + Redis。

## 文档结构

项目提供以下文档：

### 📚 完整文档（推荐）
- **COMPLETE_DOCUMENTATION.md** - 完整的文档，带有侧边栏导航和页面内跳转功能
- 包含所有其他文档的内容
- 使用 HTML 格式，支持侧边栏导航和页面内跳转

### 📖 单页文档
- **README.md** - 项目主文档（本文件）
- **DEPLOYMENT.md** - 详细部署指南
- **quick-deploy.md** - 快速部署脚本
- **PROJECT_SUMMARY.md** - 项目总结
- **OPTIMIZATION_SUMMARY.md** - 优化总结
- **HEALTH_CHECK_REPORT.md** - 健康检查报告
- **PROGRESS_UPDATE.md** - 进度更新
- **REMAINING_WORK.md** - 剩余工作列表
- **GITHUB_SECRETS.md** - GitHub Actions 配置指南
- **AUTOMATED_DEPLOYMENT_SUMMARY.md** - 自动部署流程总结

## 技术栈

### 前端
- **框架**: Nuxt 3 (Vue 3)
- **UI 库**: Element Plus
- **状态管理**: Pinia
- **开发服务器**: Vite

### 后端
- **框架**: Laravel 11
- **数据库**: MySQL 8.0
- **缓存**: Redis
- **API 认证**: Laravel Sanctum

### 基础设施
- **容器化**: Docker + Docker Compose
- **Web 服务器**: Nginx
- **构建工具**: Docker Build

## 快速开始

### 1. 环境要求
- Docker Desktop (Windows 10/11 或 macOS)
- Docker Compose (v2 或更高版本)
- Git

### 2. 项目克隆
```bash
git clone <repository-url>
cd testing
```

### 3. 启动项目
```bash
# 使用开发环境配置
docker-compose up -d

# 等待服务启动（约30秒）
sleep 30

# 初始化数据库
docker-compose exec php php artisan migrate --seed

# 构建前端
cd front
npm install
npm run generate
cd ..

# 重启 Nginx 以加载静态文件
docker-compose restart nginx
```

### 4. 访问应用
- **前端**: http://localhost
- **API**: http://localhost/api/v1
- **phpMyAdmin**: http://localhost:8080
  - 用户名: shuiyunge_user
  - 密码: WaterCloud2026!

## 生产环境部署

### 快速部署（推荐）
```bash
# 使用生产环境优化配置
chmod +x deploy-prod.sh
./deploy-prod.sh
```

### 详细部署
请参考 `DEPLOYMENT.md` 文件。

## 项目结构

```
.
├── backend/                 # Laravel 后端
│   ├── app/                # 应用核心代码
│   ├── config/             # 配置文件
│   ├── database/           # 数据库迁移和种子文件
│   ├── public/             # 公共资源和入口文件
│   ├── routes/             # 路由定义
│   ├── storage/            # 存储目录
│   └── vendor/             # 第三方依赖
├── front/                  # Nuxt 3 前端
│   ├── app/                # 应用入口和布局
│   ├── components/         # 通用组件
│   ├── pages/              # 页面组件（路由自动生成）
│   ├── stores/             # Pinia 状态管理
│   └── public/             # 静态资源
├── docker/                 # Docker 配置
│   ├── nginx/             # Nginx 配置
│   ├── php/               # PHP 配置
│   ├── mysql/             # MySQL 配置
│   └── redis/             # Redis 配置
├── docker-compose.yml     # 开发环境配置
├── docker-compose.prod.yml # 生产环境配置
├── deploy-prod.sh         # 生产环境部署脚本
├── DEPLOYMENT.md          # 完整部署文档
├── quick-deploy.md        # 快速部署指南
└── README.md              # 项目主文档
```

## 功能特性

### 前端功能
- 首页展示
- 房间列表和详情查看
- 用户中心
- 响应式设计（适配桌面和移动设备）
- 中文界面

### 后端功能
- 房间管理 API
- 用户认证和授权
- 数据验证和错误处理
- 数据库操作
- API 文档（待完善）

## 开发流程

### 代码修改
- 前端代码修改后，Nuxt 会自动热重载
- 后端代码修改后，需要重启 PHP 容器：
  ```bash
  docker restart shuiyunge-php
  ```

### 数据库迁移
每次修改数据库结构后，运行：
```bash
docker exec -it shuiyunge-php bash
php artisan migrate
```

### 查看日志
```bash
# 查看所有日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f php
docker-compose logs -f mysql
docker-compose logs -f nginx
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
docker exec -i shuiyunge-mysql mysqldump -u shuiyunge_user -pWaterCloud2026! shuiyunge > backup-$(date +%Y%m%d).sql
```

### 恢复数据库
```bash
docker exec -i shuiyunge-mysql mysql -u shuiyunge_user -pWaterCloud2026! shuiyunge < backup-file.sql
```

## 常见问题

### 容器无法启动
检查端口是否被占用：
```bash
# Windows
netstat -ano | findstr :80
netstat -ano | findstr :3306

# macOS/Linux
lsof -i :80
lsof -i :3306
```

### 无法访问 localhost
确保 Docker Desktop 的 Kubernetes 和 WSL 2 已配置正确（Windows）。

### MySQL 连接失败
- 等待容器初始化完成
- 检查 `.env` 中的配置
- 使用 `docker logs shuiyunge-mysql` 查看日志

## 开发建议

### 代码质量
- 使用 PSR-12 规范编写 PHP 代码
- 使用 ESLint 检查 Vue 代码
- 编写单元测试和集成测试

### 安全措施
- 使用强密码并定期更换
- 生产环境禁用调试模式
- 配置适当的 CORS 策略
- 使用 HTTPS 协议

## 联系方式

如有问题或建议，请通过以下方式联系：
- 项目 Issues 页面：[GitHub Issues](https://github.com/your-username/your-repository/issues)
- 邮件：your-email@example.com

## 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 许可证

本项目使用 MIT 许可证。

---

**项目状态**: ✅ 开发完成，准备部署  
**最后更新**: 2026-05-18
