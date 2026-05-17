---
title: 水云阁民宿网站设计文档
version: 1.0
date: 2026-05-17
author: Claude Code
---

# 水云阁民宿网站设计文档

## 项目概述

### 项目信息
- **项目名称**：水云阁民宿网站
- **域名**：xiaohulu.cloud
- **服务器**：腾讯云服务器 + 宝塔面板
- **开发方式**：前后端分离（Vue 3 SPA + Laravel 11 API）
- **开发阶段**：分阶段开发（核心展示→内容管理→增值功能）

### 项目定位
- **目标客户**：来柞水县牛背梁景区旅游的游客（夏季避暑群体为主）
- **核心优势**：
  - 地理位置：牛背梁景区附近
  - 环境：夏季避暑、亲近自然
  - 设施：设施完善、环境良好
- **主要功能**：推广展示、预订管理、内容发布、客户管理

## 架构设计

### 整体架构
```
┌─────────────────────────────────────────────────────────────┐
│                        用户访问层                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   访客浏览器   │  │   管理后台    │  │   手机端      │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
└─────────┼─────────────────┼─────────────────┼──────────────┘
          │                 │                 │
┌─────────▼─────────────────▼─────────────────▼──────────────┐
│                      Nginx (宝塔)                            │
│  ┌──────────────────────┐    ┌───────────────────────────┐ │
│  │  前端 xiaohulu.cloud │    │  API api.xiaohulu.cloud   │ │
│  │  (Vue 3 SPA 静态文件)│    │  (Laravel 11)             │ │
│  └──────────────────────┘    └──────────┬────────────────┘ │
└──────────────────────────────────────────┼──────────────────┘
                                           │
                              ┌────────────▼────────────┐
                              │      MySQL 数据库        │
                              └─────────────────────────┘
```

### 技术栈

| 部分 | 技术 | 说明 |
|------|------|------|
| 前端框架 | Nuxt 3.10 + Vite 5 | 服务端渲染（SSR），SEO友好 |
| 状态管理 | Pinia | Vue 3 官方推荐 |
| UI组件库 | Element Plus | 成熟、开箱即用 |
| HTTP请求 | $fetch (内置) + Pinia Plugin Persistedstate | API请求 + 本地存储 |
| 富文本编辑 | WangEditor 5 | 中文友好、零学习成本的富文本编辑器 |
| 后端框架 | Laravel 11 | 优雅的PHP框架 |
| 认证 | Laravel Sanctum / JWT | 前后端分离认证 |
| 数据库 | MySQL 8.0 | 关系型数据库 |
| 缓存 | Redis（可选） | 提高性能 |
| 队列 | Laravel Queues | 处理邮件/短信通知 |
| 文件存储 | 本地存储 / 腾讯云COS | 静态资源管理 |
| 版本控制 | Git | 代码管理，分支开发 |

## 功能模块设计

### 前台系统（Vue 3 SPA）

#### 1. 首页
```
首页
├── 英雄区 (Hero)
│   ├── 大标题："水云阁 · 避暑胜地"
│   ├── 副标题："牛背梁脚下的自然天堂"
│   ├── 背景：全屏图片（山林、民宿外观）
│   └── CTA按钮："立即预订"、"探索房间"

├── 核心优势
│   ├── 夏季避暑：气温对比图表
│   ├── 亲近自然：周围环境照片
│   ├── 设施完善：设施图标列表
│   └── 位置优势：地图+交通路线

├── 热门房型
│   ├── 卡片式布局，展示3-4个房型
│   ├── 每个卡片包含：图片、名称、价格、简短描述
│   └── "查看更多"链接

├── 客户评价
│   ├── 轮播展示
│   ├── 头像、姓名、评分、评价内容

├── 联系方式
│   ├── 地址、电话、微信
│   └── 在线预约按钮
```

#### 2. 房间列表/详情页
```
房间列表页
├── 筛选/搜索
│   ├── 按房型筛选（标准间、大床房、亲子房等）
│   ├── 按价格范围筛选
│   └── 搜索框

├── 房间卡片
│   ├── 图片、房型名称、价格、容纳人数、状态
│   └── "查看详情"按钮

房间详情页
├── 图片轮播
├── 房型信息：价格、面积、容纳人数、设施
├── 房间列表：显示同房型的可用房间
├── 价格日历：展示未来30天的价格和可预订状态
└── 预订表单：
    ├── 选择入住/退房日期
    ├── 填写姓名、电话、人数
    └── 特殊要求
```

#### 3. 预订流程
```
预订流程
┌──────────────────┐
│   选择房间日期   │
└──────┬───────────┘
       │
┌──────▼───────────┐
│   检查日期冲突   │
│   (系统自动)    │
└──────┬───────────┘
       │ 无冲突
┌──────▼───────────┐
│   填写预订信息   │
└──────┬───────────┘
       │
┌──────▼───────────┐
│   提交预订申请   │
│   发送短信/邮件   │
└──────┬───────────┘
       │
┌──────▼───────────┐
│   等待确认       │
│   (后台操作)     │
└──────────────────┘
```

#### 4. 内容系统
```
博客页面
├── 文章列表
│   ├── 分类标签（生活、风景、活动、公告）
│   └── 文章卡片：封面图、标题、摘要、阅读量

├── 文章详情
│   ├── 封面图、标题、发布时间、作者
│   ├── 内容正文（富文本）
│   └── 评论区（可选）
```

### 后台系统（Nuxt 3 + Element Plus）

#### 1. 仪表盘
```
仪表盘
├── 数据统计
│   ├── 今日预订数
│   ├── 本月订单趋势图表
│   ├── 待确认订单数
│   └── 文章发布情况

├── 快速操作
│   ├── 发布新文章
│   ├── 查看待确认订单
│   └── 添加房型
```

#### 2. 房间管理
```
房间管理
├── 房型管理
│   ├── 新增/编辑房型
│   ├── 设置价格
│   └── 管理设施

├── 房间管理
│   ├── 房间列表
│   ├── 设置房间状态（可用/维护）
│   └── 房间照片管理
```

#### 3. 预订管理
```
预订管理
├── 预订列表
│   ├── 搜索（按姓名、电话、时间）
│   └── 状态筛选

├── 预订详情
│   ├── 查看预订信息
│   ├── 确认/拒绝预订
│   ├── 发送通知
│   └── 添加内部备注
```

#### 4. 客户管理
```
客户管理
├── 客户列表
│   ├── 基础信息（姓名、电话、邮箱）
│   └── 标签筛选

├── 客户详情
│   ├── 预订历史
│   ├── 评价记录
│   └── 客户标签（自动生成）
│       ├── 常客：预订次数≥3次
│       ├── 家庭客：入住人数≥3人
│       ├── 情侣客：入住人数=2人
│       ├── 避暑客：入住月份为6-8月
│       └── 可以手动添加/修改标签
```

## 数据模型设计

### 用户表 (users)
```sql
CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
);
```

### 房型表 (room_types)
```sql
CREATE TABLE `room_types` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `capacity` tinyint NOT NULL DEFAULT '2',
  `base_price` decimal(10,2) NOT NULL,
  `amenities` json DEFAULT NULL,
  `sort_order` tinyint NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
);
```

### 房间表 (rooms)
```sql
CREATE TABLE `rooms` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `room_type_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` enum('available','maintenance') NOT NULL DEFAULT 'available',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rooms_room_type_id_foreign` (`room_type_id`),
  CONSTRAINT `rooms_room_type_id_foreign` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`)
);
```

### 预订表 (bookings)
```sql
CREATE TABLE `bookings` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` bigint UNSIGNED DEFAULT NULL,
  `room_id` bigint UNSIGNED NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date NOT NULL,
  `guest_name` varchar(255) NOT NULL,
  `guest_phone` varchar(20) NOT NULL,
  `guest_email` varchar(255) DEFAULT NULL,
  `adults` tinyint NOT NULL DEFAULT '1',
  `children` tinyint NOT NULL DEFAULT '0',
  `special_requests` text,
  `status` enum('pending','confirmed','cancelled','completed') NOT NULL DEFAULT 'pending',
  `total_price` decimal(10,2) NOT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bookings_customer_id_foreign` (`customer_id`),
  KEY `bookings_room_id_foreign` (`room_id`),
  CONSTRAINT `bookings_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `bookings_room_id_foreign` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`)
);
```

### 客户表 (customers)
```sql
CREATE TABLE `customers` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `tags` json DEFAULT NULL,
  `preferences` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customers_phone_unique` (`phone`)
);
```

### 文章表 (articles)
```sql
CREATE TABLE `articles` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `excerpt` text,
  `featured_image` varchar(255) DEFAULT NULL,
  `type` enum('blog','notice') NOT NULL DEFAULT 'blog',
  `status` enum('draft','published') NOT NULL DEFAULT 'draft',
  `published_at` timestamp NULL DEFAULT NULL,
  `author_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `articles_slug_unique` (`slug`),
  KEY `articles_author_id_foreign` (`author_id`),
  CONSTRAINT `articles_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`)
);
```

## 开发阶段计划

### 第一阶段（核心展示+预订）- 15天
**目标：网站上线，能展示和接单**

| 天数 | 任务 |
|------|------|
| 1-2 | 服务器环境配置、域名解析、基础框架搭建 |
| 3-6 | 后端：数据库设计、认证系统、房间/预订API |
| 7-10 | 前台：首页、房间列表、详情页、预订表单 |
| 11-12 | 后台：基础管理功能、预订处理 |
| 13-14 | 测试、优化、部署到生产环境 |
| 15 | 上线前检查、SEO基础配置 |

### 第二阶段（内容+客户管理）- 10天
**目标：内容营销和客户留存**

| 天数 | 任务 |
|------|------|
| 1-3 | 博客系统：富文本编辑、列表/详情页 |
| 4-6 | 客户管理：客户画像、预订历史、反馈 |
| 7-8 | 后台优化：数据统计图表、通知系统 |
| 9-10 | 测试、部署、培训使用 |

### 第三阶段（增值功能）- 7天
**目标：提升用户体验和营收**

| 天数 | 任务 |
|------|------|
| 1-3 | 在线支付（支付宝/微信） |
| 4-5 | 日历房态管理 |
| 6-7 | 会员/积分系统 |

## 部署方案

### 宝塔面板配置
1. **软件安装**：Nginx 1.24 + MySQL 8.0 + PHP 8.2
2. **网站创建**：
   - 主站：`xiaohulu.cloud`，根目录：`/www/wwwroot/xiaohulu/front`
   - API站：`api.xiaohulu.cloud`，根目录：`/www/wwwroot/xiaohulu/backend`
3. **SSL证书**：宝塔免费SSL（Let's Encrypt）
4. **Nginx配置**：
   主站（Nuxt SSR）需要配置：
   ```nginx
   location / {
       try_files $uri $uri/ /index.html;
   }
   
   location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
       expires 30d;
       add_header Cache-Control "public, immutable";
   }
   ```
5. **防火墙**：开启必要端口（80, 443, 22）

### 项目部署
1. **前端部署**：
   ```bash
   cd front
   npm run build
   # 将 dist 文件夹内容上传到宝塔的 /www/wwwroot/xiaohulu/front
   ```

2. **后端部署**：
   ```bash
   cd backend
   # 生成优化后的自动加载文件
   composer install --optimize-autoloader --no-dev
   # 生成环境变量文件并配置
   cp .env.example .env
   php artisan key:generate
   # 配置数据库连接
   # 运行数据库迁移和填充
   php artisan migrate --seed
   # 配置队列
   php artisan queue:work --daemon
   ```

### 开发过程中的测试
- 创建测试域名：`test.xiaohulu.cloud`
- 每次功能完成后先在测试环境验证
- 测试通过后再部署到生产环境

### Git 版本控制
1. **仓库结构**：
   - 前端：`xiaohulu-front`（Nuxt 3）
   - 后端：`xiaohulu-backend`（Laravel）

2. **分支策略**：
   - `main`：生产分支，只能合并，不能直接提交
   - `dev`：开发分支，每天合并到 main
   - `feature/xxx`：功能分支，完成后合并到 dev 测试

3. **提交规范**：
   - `feat: 新增功能`
   - `fix: 修复bug`
   - `docs: 更新文档`
   - `refactor: 重构代码`

## 可扩展性设计

### 模块化架构
```
项目结构
├── backend (Laravel)
│   ├── app/
│   │   ├── Http/Controllers
│   │   │   ├── Api/V1/
│   │   │   │   ├── Auth/
│   │   │   │   ├── Rooms/
│   │   │   │   ├── Bookings/
│   │   │   │   └── ...
│   │   │   └── ...
│   │   └── Models/
│   └── routes/
│       └── api.php

└── front (Vue)
    ├── src/
    │   ├── components/
    │   ├── pages/
    │   ├── stores/
    │   └── api/
    │       └── v1/
    └── ...
```

### 接口版本管理
- 使用 `api.xiaohulu.cloud/v1/` 前缀
- 未来升级时使用 `/v2/` 前缀，保持向后兼容

### 组件化设计
- 前端组件抽象为可复用组件
- 后端服务接口标准化

## 安全考虑

### 前端安全
1. XSS防护：使用 Vue 的数据绑定、DOMPurify 清洁用户输入
2. CSRF：使用 SameSite cookies
3. API 请求：使用 HTTPS，设置合理的 CORS 策略

### 后端安全
1. 输入验证：使用 Laravel 的验证规则
2. SQL注入：使用 Eloquent ORM 或参数化查询
3. 认证授权：使用 Laravel Sanctum
4. 密码策略：强制复杂密码、密码重置
5. 登录防护：5次登录失败后锁定5分钟，记录登录IP
6. 接口限流：预订、查询等接口加限流（每分钟最多5次）
7. 日志记录：记录关键操作，便于排查问题

## 性能优化

### 前端优化
1. 代码分割：使用 Vite 的动态导入
2. 图片优化：使用 WebP 格式、懒加载
3. 缓存策略：合理设置 HTTP 缓存头
4. CDN：使用腾讯云CDN加速静态资源

### 后端优化
1. 查询优化：合理使用索引、避免N+1问题
2. 缓存：使用 Redis 缓存频繁查询的数据
3. 队列：将邮件/短信发送等耗时操作放入队列
4. 数据库优化：定期优化表、清理日志

## 总结

本设计采用前后端分离架构，既符合现代开发习惯，又具有良好的可扩展性。分阶段开发策略让项目能快速上线产生价值，同时为后续功能的扩展奠定基础。通过宝塔面板的可视化管理，降低了部署和维护的难度，让你能专注于业务逻辑的开发。

设计文档已完成，需要我创建实现计划吗？
