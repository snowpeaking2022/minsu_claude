<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>水云阁民宿管理系统 - 完整文档</title>
    <style>
        :root {
            --primary-color: #4a90d9;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --background-color: #f4f6f8;
            --text-color: #2c3e50;
            --border-color: #e1e4e8;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: var(--text-color);
            background-color: var(--background-color);
        }

        .container {
            display: flex;
            max-width: 1400px;
            margin: 0 auto;
            background-color: white;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }

        /* 侧边栏导航 */
        .sidebar {
            width: 300px;
            background-color: #f8f9fa;
            border-right: 1px solid var(--border-color);
            padding: 20px 0;
            position: sticky;
            top: 0;
            height: 100vh;
            overflow-y: auto;
        }

        .sidebar h2 {
            font-size: 1.2rem;
            padding: 0 20px;
            margin-bottom: 15px;
            border-bottom: 2px solid var(--primary-color);
            color: var(--primary-color);
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar li {
            margin-bottom: 5px;
        }

        .sidebar a {
            display: block;
            padding: 10px 20px;
            color: var(--dark-color);
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .sidebar a:hover {
            background-color: var(--light-color);
            border-left-color: var(--primary-color);
            color: var(--primary-color);
            padding-left: 25px;
        }

        .sidebar .active {
            background-color: var(--light-color);
            border-left-color: var(--primary-color);
            color: var(--primary-color);
        }

        /* 主内容区 */
        .content {
            flex: 1;
            padding: 40px;
            max-width: 800px;
        }

        /* 标题样式 */
        h1 {
            font-size: 2.5rem;
            margin-bottom: 20px;
            color: var(--dark-color);
            border-bottom: 3px solid var(--primary-color);
            padding-bottom: 10px;
        }

        h2 {
            font-size: 2rem;
            margin-top: 40px;
            margin-bottom: 20px;
            color: var(--dark-color);
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 8px;
        }

        h3 {
            font-size: 1.5rem;
            margin-top: 30px;
            margin-bottom: 15px;
            color: var(--dark-color);
        }

        /* 目录导航 */
        .table-of-contents {
            background-color: #f8f9fa;
            border-left: 4px solid var(--primary-color);
            padding: 20px;
            margin: 30px 0;
            border-radius: 0 5px 5px 0;
        }

        .table-of-contents h3 {
            margin-top: 0;
            margin-bottom: 15px;
            color: var(--primary-color);
        }

        .table-of-contents ul {
            list-style: none;
            padding-left: 20px;
        }

        .table-of-contents li {
            margin-bottom: 10px;
        }

        .table-of-contents a {
            color: var(--primary-color);
            text-decoration: none;
            font-size: 0.95rem;
            transition: color 0.3s ease;
        }

        .table-of-contents a:hover {
            color: var(--primary-color);
            text-decoration: underline;
        }

        /* 文档内容样式 */
        .section {
            margin-bottom: 30px;
        }

        .section p {
            margin-bottom: 15px;
            font-size: 1rem;
            line-height: 1.7;
        }

        .section ul, .section ol {
            margin-left: 25px;
            margin-bottom: 15px;
        }

        .section li {
            margin-bottom: 8px;
        }

        /* 代码块样式 */
        pre {
            background-color: #f8f9fa;
            border: 1px solid var(--border-color);
            border-radius: 5px;
            padding: 15px;
            overflow-x: auto;
            margin: 15px 0;
        }

        code {
            background-color: #f8f9fa;
            padding: 2px 5px;
            border-radius: 3px;
            font-family: monospace;
            font-size: 0.9em;
        }

        pre code {
            background-color: transparent;
            padding: 0;
        }

        /* 表格样式 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
            font-size: 0.95rem;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        th {
            background-color: #f8f9fa;
            font-weight: 600;
        }

        /* 链接样式 */
        a {
            color: var(--primary-color);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        a:hover {
            color: #337ab7;
            text-decoration: underline;
        }

        /* 图片和引用 */
        .note {
            background-color: var(--info-color);
            color: white;
            padding: 15px;
            border-radius: 5px;
            margin: 15px 0;
            border-left: 4px solid var(--dark-color);
        }

        .warning {
            background-color: var(--warning-color);
            color: white;
            padding: 15px;
            border-radius: 5px;
            margin: 15px 0;
            border-left: 4px solid var(--dark-color);
        }

        .important {
            background-color: var(--danger-color);
            color: white;
            padding: 15px;
            border-radius: 5px;
            margin: 15px 0;
            border-left: 4px solid var(--dark-color);
        }

        /* 打印样式 */
        @media print {
            .container {
                box-shadow: none;
            }

            .sidebar {
                display: none;
            }

            .content {
                max-width: 100%;
                padding: 20px;
            }

            h1, h2, h3 {
                page-break-after: avoid;
            }

            pre {
                white-space: pre-wrap;
                overflow: visible;
            }
        }

        /* 响应式设计 */
        @media (max-width: 992px) {
            .container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                border-right: none;
                border-bottom: 1px solid var(--border-color);
            }

            .content {
                padding: 30px;
            }

            h1 {
                font-size: 2rem;
            }

            h2 {
                font-size: 1.6rem;
            }

            h3 {
                font-size: 1.3rem;
            }
        }

        /* 滚动到顶部按钮 */
        .scroll-top {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background-color: var(--primary-color);
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            opacity: 0;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .scroll-top:hover {
            background-color: #337ab7;
            transform: translateY(-5px);
        }

        .scroll-top.visible {
            opacity: 1;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 侧边栏导航 -->
        <div class="sidebar">
            <h2>📚 文档导航</h2>
            <ul>
                <li><a href="#introduction" class="active">项目介绍</a></li>
                <li><a href="#quick-start">快速开始</a></li>
                <li><a href="#project-structure">项目结构</a></li>
                <li><a href="#development">开发环境</a></li>
                <li><a href="#features">功能特性</a></li>
                <li><a href="#api-documentation">API 文档</a></li>
                <li><a href="#deployment">部署流程</a></li>
                <li><a href="#automated-deployment">自动部署</a></li>
                <li><a href="#health-check">健康检查</a></li>
                <li><a href="#optimization">优化总结</a></li>
                <li><a href="#remaining-work">剩余工作</a></li>
                <li><a href="#faq">常见问题</a></li>
            </ul>
        </div>

        <!-- 主内容区 -->
        <div class="content">
            <h1>水云阁民宿管理系统 - 完整文档</h1>
            
            <!-- 目录导航 -->
            <div class="table-of-contents">
                <h3>📖 目录导航</h3>
                <ul>
                    <li><a href="#introduction">项目介绍</a></li>
                    <li><a href="#quick-start">快速开始</a></li>
                    <li><a href="#project-structure">项目结构</a></li>
                    <li><a href="#development">开发环境</a></li>
                    <li><a href="#features">功能特性</a></li>
                    <li><a href="#api-documentation">API 文档</a></li>
                    <li><a href="#deployment">部署流程</a></li>
                    <li><a href="#automated-deployment">自动部署</a></li>
                    <li><a href="#health-check">健康检查</a></li>
                    <li><a href="#optimization">优化总结</a></li>
                    <li><a href="#remaining-work">剩余工作</a></li>
                    <li><a href="#faq">常见问题</a></li>
                </ul>
            </div>

            <!-- 项目介绍 -->
            <div id="introduction" class="section">
                <h2>项目介绍</h2>
                <p>水云阁民宿管理系统是一个基于 Docker 容器化部署的全栈应用，旨在提供便捷的酒店管理功能。系统采用前后端分离架构，前端使用 Nuxt 3 + Vue 3 + Element Plus，后端使用 Laravel 11 + MySQL 8.0 + Redis。</p>
                <h3>技术栈</h3>
                <ul>
                    <li><strong>前端</strong>: Nuxt 3 (Vue 3), Element Plus, Pinia</li>
                    <li><strong>后端</strong>: Laravel 11, MySQL 8.0, Redis</li>
                    <li><strong>基础设施</strong>: Docker + Docker Compose, Nginx</li>
                    <li><strong>API 认证</strong>: Laravel Sanctum</li>
                </ul>
                <h3>项目状态</h3>
                <div style="display: flex; gap: 10px; margin-top: 15px;">
                    <div style="padding: 8px 16px; background-color: #28a745; color: white; border-radius: 5px;">✅ 开发完成</div>
                    <div style="padding: 8px 16px; background-color: #17a2b8; color: white; border-radius: 5px;">📚 文档齐全</div>
                    <div style="padding: 8px 16px; background-color: #ffc107; color: white; border-radius: 5px;">🚀 部署流程完善</div>
                </div>
            </div>

            <!-- 快速开始 -->
            <div id="quick-start" class="section">
                <h2>快速开始</h2>
                <h3>1. 环境要求</h3>
                <ul>
                    <li>Docker Desktop (Windows 10/11 或 macOS)</li>
                    <li>Docker Compose (v2 或更高版本)</li>
                    <li>Git</li>
                    <li>Node.js 18+ (用于前端开发)</li>
                </ul>
                <h3>2. 项目克隆</h3>
                <pre><code>git clone &lt;repository-url&gt;
cd testing</code></pre>
                <h3>3. 启动项目</h3>
                <pre><code># 使用开发环境配置
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
docker-compose restart nginx</code></pre>
                <h3>4. 访问应用</h3>
                <ul>
                    <li><strong>前端</strong>: http://localhost</li>
                    <li><strong>API</strong>: http://localhost/api/v1</li>
                    <li><strong>phpMyAdmin</strong>: http://localhost:8080 (用户名: shuiyunge_user, 密码: WaterCloud2026!)</li>
                </ul>
            </div>

            <!-- 项目结构 -->
            <div id="project-structure" class="section">
                <h2>项目结构</h2>
                <pre><code>.
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
├── README.md              # 项目主文档
├── DEPLOYMENT.md          # 完整部署文档
├── quick-deploy.md        # 快速部署指南
└── COMPLETE_DOCUMENTATION.md # 本文件</code></pre>
            </div>

            <!-- 开发环境 -->
            <div id="development" class="section">
                <h2>开发环境</h2>
                <h3>开发流程</h3>
                <h4>代码修改</h4>
                <ul>
                    <li>前端代码修改后，Nuxt 会自动热重载</li>
                    <li>后端代码修改后，需要重启 PHP 容器：
                        <pre><code>docker restart shuiyunge-php</code></pre>
                    </li>
                </ul>
                <h4>数据库迁移</h4>
                <p>每次修改数据库结构后，运行：</p>
                <pre><code>docker exec -it shuiyunge-php bash
php artisan migrate</code></pre>
                <h4>查看日志</h4>
                <pre><code># 查看所有日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f php
docker-compose logs -f mysql
docker-compose logs -f nginx</code></pre>
                <h3>停止和清理</h3>
                <pre><code># 停止容器
docker-compose stop

# 启动容器（不重建）
docker-compose start

# 停止并删除容器（保留数据）
docker-compose down

# 停止并删除容器和数据
docker-compose down -v</code></pre>
                <h3>数据备份</h3>
                <pre><code># 备份数据库
docker exec -i shuiyunge-mysql mysqldump -u shuiyunge_user -pWaterCloud2026! shuiyunge > backup-$(date +%Y%m%d).sql

# 恢复数据库
docker exec -i shuiyunge-mysql mysql -u shuiyunge_user -pWaterCloud2026! shuiyunge < backup-file.sql</code></pre>
            </div>

            <!-- 功能特性 -->
            <div id="features" class="section">
                <h2>功能特性</h2>
                <h3>前端功能</h3>
                <ul>
                    <li>首页展示</li>
                    <li>房间列表和详情查看</li>
                    <li>用户中心</li>
                    <li>响应式设计（适配桌面和移动设备）</li>
                    <li>中文界面</li>
                </ul>
                <h3>后端功能</h3>
                <ul>
                    <li>房间管理 API</li>
                    <li>用户认证和授权</li>
                    <li>数据验证和错误处理</li>
                    <li>数据库操作</li>
                    <li>API 文档（已完善）</li>
                </ul>
            </div>

            <!-- API 文档 -->
            <div id="api-documentation" class="section">
                <h2>API 文档</h2>
                <h3>基础信息</h3>
                <ul>
                    <li><strong>API 版本</strong>: v1</li>
                    <li><strong>基础 URL</strong>: <code>https://localhost/api/v1</code></li>
                    <li><strong>认证方式</strong>: Laravel Sanctum（Bearer Token）</li>
                    <li><strong>响应格式</strong>: JSON</li>
                </ul>
                <h3>公共接口</h3>
                <h4>1. 健康检查</h4>
                <pre><code>GET /health</code></pre>
                <p>返回系统健康状态信息。</p>
                <h5>请求参数</h5>
                <p>无</p>
                <h5>响应示例</h5>
                <pre><code>{
  "status": "healthy",
  "timestamp": "2026-05-19T20:30:00.000000Z",
  "version": "1.0.0"
}</code></pre>
                <h4>2. 用户注册</h4>
                <pre><code>POST /register</code></pre>
                <p>注册新用户。</p>
                <h5>请求参数</h5>
                <ul>
                    <li><code>name</code> - 用户名 (必填)</li>
                    <li><code>email</code> - 邮箱 (必填)</li>
                    <li><code>password</code> - 密码 (必填)</li>
                    <li><code>password_confirmation</code> - 密码确认 (必填)</li>
                </ul>
                <h5>请求示例</h5>
                <pre><code>{
  "name": "张三",
  "email": "zhangsan@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}</code></pre>
                <h5>响应示例</h5>
                <pre><code>{
  "token": "1|some-random-token-here",
  "user": {
    "id": 1,
    "name": "张三",
    "email": "zhangsan@example.com",
    "email_verified_at": null,
    "created_at": "2026-05-19T20:30:00.000000Z",
    "updated_at": "2026-05-19T20:30:00.000000Z"
  }
}</code></pre>
                <h4>3. 用户登录</h4>
                <pre><code>POST /login</code></pre>
                <p>用户登录并获取 token。</p>
                <h5>请求参数</h5>
                <ul>
                    <li><code>email</code> - 邮箱 (必填)</li>
                    <li><code>password</code> - 密码 (必填)</li>
                </ul>
                <h5>请求示例</h5>
                <pre><code>{
  "email": "zhangsan@example.com",
  "password": "password123"
}</code></pre>
                <h5>响应示例</h5>
                <pre><code>{
  "token": "1|some-random-token-here",
  "user": {
    "id": 1,
    "name": "张三",
    "email": "zhangsan@example.com",
    "email_verified_at": null,
    "created_at": "2026-05-19T20:30:00.000000Z",
    "updated_at": "2026-05-19T20:30:00.000000Z"
  }
}</code></pre>
                <h4>4. 房间列表</h4>
                <pre><code>GET /rooms</code></pre>
                <p>获取所有可用房间信息。</p>
                <h5>请求参数</h5>
                <p>无</p>
                <h5>响应示例</h5>
                <pre><code>{
  "data": [
    {
      "id": 1,
      "name": "标准间 1",
      "room_type_id": 1,
      "status": "available",
      "room_type": {
        "id": 1,
        "name": "标准间",
        "description": "配备两张单人床，适合两人入住",
        "capacity": 2,
        "base_price": "200.00",
        "amenities": ["wifi", "tv", "air_conditioner"],
        "sort_order": 1,
        "status": "active"
      }
    }
  ]
}</code></pre>
                <h4>5. 房间详情</h4>
                <pre><code>GET /rooms/{id}</code></pre>
                <p>获取单个房间的详细信息。</p>
                <h5>路径参数</h5>
                <ul>
                    <li><code>id</code> - 房间 ID</li>
                </ul>
                <h5>响应示例</h5>
                <pre><code>{
  "data": {
    "id": 1,
    "name": "标准间 1",
    "room_type_id": 1,
    "status": "available",
    "room_type": {
      "id": 1,
      "name": "标准间",
      "description": "配备两张单人床，适合两人入住",
      "capacity": 2,
      "base_price": "200.00",
      "amenities": ["wifi", "tv", "air_conditioner"],
      "sort_order": 1,
      "status": "active"
    }
  }
}</code></pre>
                <h4>6. 房间类型</h4>
                <pre><code>GET /room-types</code></pre>
                <p>获取所有可用的房间类型信息。</p>
                <h5>请求参数</h5>
                <p>无</p>
                <h5>响应示例</h5>
                <pre><code>{
  "data": [
    {
      "id": 1,
      "name": "标准间",
      "description": "配备两张单人床，适合两人入住",
      "capacity": 2,
      "base_price": "200.00",
      "amenities": ["wifi", "tv", "air_conditioner"],
      "sort_order": 1,
      "status": "active"
    },
    {
      "id": 2,
      "name": "豪华套房",
      "description": "配备大床和沙发，适合两人入住",
      "capacity": 2,
      "base_price": "400.00",
      "amenities": ["wifi", "tv", "air_conditioner", "minibar"],
      "sort_order": 2,
      "status": "active"
    }
  ]
}</code></pre>
                <h4>7. 创建预订</h4>
                <pre><code>POST /bookings</code></pre>
                <p>创建新的房间预订。</p>
                <h5>请求参数</h5>
                <ul>
                    <li><code>room_id</code> - 房间 ID（必填）</li>
                    <li><code>check_in</code> - 入住日期（必填，格式：YYYY-MM-DD）</li>
                    <li><code>check_out</code> - 退房日期（必填，格式：YYYY-MM-DD）</li>
                    <li><code>guest_name</code> - 客人姓名（必填）</li>
                    <li><code>guest_phone</code> - 客人电话（必填）</li>
                    <li><code>guest_email</code> - 客人邮箱（可选）</li>
                    <li><code>adults</code> - 成人数量（必填，最少 1 人）</li>
                    <li><code>children</code> - 儿童数量（可选，最少 0 人）</li>
                    <li><code>special_requests</code> - 特殊要求（可选）</li>
                </ul>
                <h5>请求示例</h5>
                <pre><code>{
  "room_id": 1,
  "check_in": "2026-05-20",
  "check_out": "2026-05-22",
  "guest_name": "张三",
  "guest_phone": "13800138000",
  "guest_email": "zhangsan@example.com",
  "adults": 2,
  "children": 1,
  "special_requests": "需要无烟房"
}</code></pre>
                <h5>响应示例</h5>
                <pre><code>{
  "data": {
    "id": 1,
    "customer_id": 1,
    "room_id": 1,
    "check_in": "2026-05-20",
    "check_out": "2026-05-22",
    "guest_name": "张三",
    "guest_phone": "13800138000",
    "guest_email": "zhangsan@example.com",
    "adults": 2,
    "children": 1,
    "special_requests": "需要无烟房",
    "total_price": "400.00",
    "status": "pending"
  }
}</code></pre>
                <h3>需要认证的接口</h3>
                <p>这些接口需要在请求头中添加 <code>Authorization: Bearer {token}</code>。</p>
                <h4>1. 获取预订列表</h4>
                <pre><code>GET /bookings</code></pre>
                <p>获取用户的所有预订信息。</p>
                <h5>请求参数</h5>
                <p>无</p>
                <h5>响应示例</h5>
                <pre><code>{
  "data": [
    {
      "id": 1,
      "customer_id": 1,
      "room_id": 1,
      "check_in": "2026-05-20",
      "check_out": "2026-05-22",
      "guest_name": "张三",
      "guest_phone": "13800138000",
      "guest_email": "zhangsan@example.com",
      "adults": 2,
      "children": 1,
      "special_requests": "需要无烟房",
      "total_price": "400.00",
      "status": "pending"
    }
  ]
}</code></pre>
                <h4>2. 获取预订详情</h4>
                <pre><code>GET /bookings/{id}</code></pre>
                <p>获取单个预订的详细信息。</p>
                <h5>路径参数</h5>
                <ul>
                    <li><code>id</code> - 预订 ID</li>
                </ul>
                <h5>响应示例</h5>
                <pre><code>{
  "data": {
    "id": 1,
    "customer_id": 1,
    "room_id": 1,
    "check_in": "2026-05-20",
    "check_out": "2026-05-22",
    "guest_name": "张三",
    "guest_phone": "13800138000",
    "guest_email": "zhangsan@example.com",
    "adults": 2,
                    "children": 1,
                    "special_requests": "需要无烟房",
                    "total_price": "400.00",
                    "status": "pending"
                  }
                }</code></pre>
                <h4>3. 更新预订</h4>
                <pre><code>PUT /bookings/{id}</code></pre>
                <p>更新预订信息。</p>
                <h5>路径参数</h5>
                <ul>
                    <li><code>id</code> - 预订 ID</li>
                </ul>
                <h5>请求参数</h5>
                <ul>
                    <li><code>check_in</code> - 入住日期 (可选)</li>
                    <li><code>check_out</code> - 退房日期 (可选)</li>
                    <li><code>guest_name</code> - 客人姓名 (可选)</li>
                    <li><code>guest_phone</code> - 客人电话 (可选)</li>
                    <li><code>guest_email</code> - 客人邮箱 (可选)</li>
                    <li><code>adults</code> - 成人数量 (可选)</li>
                    <li><code>children</code> - 儿童数量 (可选)</li>
                    <li><code>special_requests</code> - 特殊要求 (可选)</li>
                    <li><code>status</code> - 预订状态 (可选: pending, confirmed, cancelled, completed)</li>
                </ul>
                <h5>请求示例</h5>
                <pre><code>{
  "status": "confirmed",
  "special_requests": "需要加一张婴儿床"
}</code></pre>
                <h5>响应示例</h5>
                <pre><code>{
  "data": {
    "id": 1,
    "customer_id": 1,
    "room_id": 1,
    "check_in": "2026-05-20",
    "check_out": "2026-05-22",
    "guest_name": "张三",
    "guest_phone": "13800138000",
    "guest_email": "zhangsan@example.com",
    "adults": 2,
    "children": 1,
    "special_requests": "需要加一张婴儿床",
    "total_price": "400.00",
    "status": "confirmed"
  }
}</code></pre>
                <h4>4. 删除预订</h4>
                <pre><code>DELETE /bookings/{id}</code></pre>
                <p>删除预订。</p>
                <h5>路径参数</h5>
                <ul>
                    <li><code>id</code> - 预订 ID</li>
                </ul>
                <h5>响应示例</h5>
                <pre><code>{
  "message": "预订已删除"
}</code></pre>
            </div>

            <!-- 部署流程 -->
            <div id="deployment" class="section">
                <h2>部署流程</h2>
                <h3>生产环境部署</h3>
                <h4>方法 1: 使用部署脚本</h4>
                <pre><code>chmod +x deploy-prod.sh
./deploy-prod.sh</code></pre>
                <h4>方法 2: 快速部署</h4>
                <p>参考 <code>quick-deploy.md</code> 文件。</p>
                <h3>部署步骤</h3>
                <ol>
                    <li>服务器准备和环境检查</li>
                    <li>项目克隆或文件上传</li>
                    <li>配置检查和验证</li>
                    <li>服务启动</li>
                    <li>数据库初始化</li>
                    <li>前端构建</li>
                    <li>服务优化</li>
                    <li>访问验证</li>
                </ol>
            </div>

            <!-- 自动部署 -->
            <div id="automated-deployment" class="section">
                <h2>自动部署</h2>
                <h3>GitHub Actions 配置</h3>
                <p>需要在 GitHub 仓库中配置以下 Secrets：</p>
                <ul>
                    <li><code>SERVER_HOST</code> - 服务器 IP 地址或域名</li>
                    <li><code>SERVER_USER</code> - SSH 用户名（通常是 root）</li>
                    <li><code>SSH_PRIVATE_KEY</code> - 服务器的 SSH 私钥</li>
                    <li><code>SSH_PORT</code> - SSH 连接端口（默认为 22）</li>
                </ul>
                <h3>工作流程</h3>
                <ul>
                    <li><strong>deploy.yml</strong> - 完整的自动化部署流程（需要 Docker Hub）</li>
                    <li><strong>deploy-simple.yml</strong> - 简化的自动化部署流程（不需要 Docker Hub）</li>
                </ul>
                <h3>触发方式</h3>
                <ul>
                    <li>推送到 <code>master</code> 分支自动触发</li>
                    <li>在 GitHub Actions 页面手动触发</li>
                </ul>
            </div>

            <!-- 健康检查 -->
            <div id="health-check" class="section">
                <h2>健康检查</h2>
                <h3>运行预部署检查</h3>
                <pre><code>./pre-deploy-check.sh</code></pre>
                <h3>检查服务状态</h3>
                <pre><code># Docker 容器状态
docker-compose ps

# 服务健康检查
curl -I http://localhost/api/v1/health</code></pre>
                <h3>健康检查报告</h3>
                <p>运行预部署检查脚本会生成详细的健康检查报告。</p>
            </div>

            <!-- 优化总结 -->
            <div id="optimization" class="section">
                <h2>优化总结</h2>
                <h3>配置优化</h3>
                <ul>
                    <li>PHP Opcache 启用</li>
                    <li>MySQL 性能配置</li>
                    <li>Redis 内存配置</li>
                    <li>Nginx 静态文件缓存</li>
                    <li>资源限制和日志配置</li>
                </ul>
                <h3>应用优化</h3>
                <pre><code># Laravel 生产环境优化
php artisan config:cache
php artisan route:cache
php artisan view:cache</code></pre>
            </div>

            <!-- 剩余工作 -->
            <div id="remaining-work" class="section">
                <h2>剩余工作</h2>
                <h3>高优先级（必须完成）</h3>
                <ul>
                    <li>✅ 项目清理</li>
                    <li>✅ 开发环境验证</li>
                    <li>✅ 创建主 README.md</li>
                </ul>
                <h3>中优先级（部分完成）</h3>
                <ul>
                    <li>✅ 代码质量与安全检查</li>
                    <li>✅ 部署准备</li>
                    <li>⏸️ 备份与恢复（已在文档中说明）</li>
                </ul>
                <h3>低优先级（待处理）</h3>
                <ul>
                    <li>⏸️ 功能完善</li>
                    <li>⏸️ 测试</li>
                    <li>⏸️ 监控与日志</li>
                </ul>
            </div>

            <!-- 常见问题 -->
            <div id="faq" class="section">
                <h2>常见问题</h2>
                <h3>Q: 如何启用 GitHub Actions？</h3>
                <p>A: 进入仓库的 Settings > Actions > General，确保启用 Actions 功能。</p>
                <h3>Q: 部署失败时如何处理？</h3>
                <p>A: 首先查看 GitHub Actions 日志，根据错误信息修复问题，然后使用回滚脚本恢复。</p>
                <h3>Q: 如何配置自定义域名？</h3>
                <p>A: 修改 <code>docker/nginx/conf.d/app.conf</code>，添加域名配置，重新配置 SSL 证书。</p>
                <h3>Q: 数据库迁移失败怎么办？</h3>
                <p>A: 检查数据库连接是否正常，查看迁移日志，回滚到之前的版本。</p>
                <h3>Q: 如何调整资源限制？</h3>
                <p>A: 修改 <code>docker-compose.prod.yml</code> 中的 resources 配置。</p>
            </div>
        </div>
    </div>

    <!-- 滚动到顶部按钮 -->
    <div class="scroll-top">↑</div>

    <script>
        // 页面加载完成后执行
        document.addEventListener('DOMContentLoaded', function() {
            // 侧边栏导航点击事件
            const sidebarLinks = document.querySelectorAll('.sidebar a');
            sidebarLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    // 移除所有 active 类
                    sidebarLinks.forEach(l => l.classList.remove('active'));
                    // 给当前点击的链接添加 active 类
                    this.classList.add('active');
                });
            });

            // 滚动到顶部按钮
            const scrollTopBtn = document.querySelector('.scroll-top');
            window.addEventListener('scroll', function() {
                if (window.pageYOffset > 300) {
                    scrollTopBtn.classList.add('visible');
                } else {
                    scrollTopBtn.classList.remove('visible');
                }
            });

            scrollTopBtn.addEventListener('click', function() {
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            });

            // 页面滚动时高亮对应的导航链接
            window.addEventListener('scroll', function() {
                const sections = document.querySelectorAll('.section');
                const scrollPosition = window.pageYOffset + 100;

                sections.forEach(section => {
                    const sectionTop = section.offsetTop;
                    const sectionBottom = sectionTop + section.offsetHeight;

                    if (scrollPosition >= sectionTop && scrollPosition < sectionBottom) {
                        // 移除所有 active 类
                        sidebarLinks.forEach(link => link.classList.remove('active'));
                        // 找到对应的导航链接并添加 active 类
                        const sectionId = section.getAttribute('id');
                        const correspondingLink = document.querySelector(`.sidebar a[href="#${sectionId}"]`);
                        if (correspondingLink) {
                            correspondingLink.classList.add('active');
                        }
                    }
                });
            });
        });
    </script>
</body>
</html>
