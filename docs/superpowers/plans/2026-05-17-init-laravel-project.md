# 初始化 Laravel 11 项目实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在 Docker 容器中初始化 Laravel 11 项目，配置数据库连接和 Sanctum 认证

**Architecture:** 使用 Docker 容器化环境，在 shuiyunge-php 容器中安装 Laravel 11，配置 MySQL 数据库连接，安装 Sanctum 认证，创建健康检查路由

**Tech Stack:** Laravel 11, Docker, MySQL, PHP 8.2, Composer, Sanctum

---

## Task 1: 进入 PHP 容器并检查环境

**Files:**
- 无

- [ ] **Step 1: 进入 shuiyunge-php 容器**

```powershell
docker exec -it shuiyunge-php bash
```

- [ ] **Step 2: 检查当前工作目录**

```bash
pwd && ls -la
```

- [ ] **Step 3: 检查 Composer 是否安装**

```bash
composer --version
```

## Task 2: 初始化 Laravel 11 项目

**Files:**
- 创建: `/var/www/html/*` (Laravel 项目文件)

- [ ] **Step 1: 使用 Composer 创建 Laravel 11 项目**

```bash
cd /var/www/html && composer create-project laravel/laravel . --prefer-dist
```

- [ ] **Step 2: 检查项目文件是否创建成功**

```bash
ls -la /var/www/html
```

## Task 3: 配置 .env 文件

**Files:**
- 创建: `/var/www/html/.env`
- 参考: `/var/www/html/.env.example`

- [ ] **Step 1: 复制 .env.example 为 .env**

```bash
cd /var/www/html && cp .env.example .env
```

- [ ] **Step 2: 配置 .env 文件**

```bash
cd /var/www/html && cat > .env << 'EOF'
APP_NAME=水云阁民宿
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_TIMEZONE=UTC
APP_URL=http://api.xiaohulu.cloud

LOG_CHANNEL=stack
LOG_STACK=single
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=shuiyunge
DB_USERNAME=shuiyunge_user
DB_PASSWORD=WaterCloud2026!

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120
SESSION_DOMAIN=xiaohulu.cloud

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
VITE_PUSHER_HOST="${PUSHER_HOST}"
VITE_PUSHER_PORT="${PUSHER_PORT}"
VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"

SANCTUM_STATEFUL_DOMAINS=xiaohulu.cloud,api.xiaohulu.cloud
EOF
```

## Task 4: 生成密钥和数据库迁移

**Files:**
- 修改: `/var/www/html/.env` (添加 APP_KEY)
- 创建: `/var/www/html/database/migrations/*`
- 创建: `/var/www/html/database/seeders/*`

- [ ] **Step 1: 生成应用密钥**

```bash
cd /var/www/html && php artisan key:generate
```

- [ ] **Step 2: 运行数据库迁移和种子**

```bash
cd /var/www/html && php artisan migrate --seed
```

## Task 5: 安装和配置 Sanctum 认证

**Files:**
- 修改: `/var/www/html/composer.json`
- 创建: `/var/www/html/config/sanctum.php`
- 创建: `/var/www/html/database/migrations/*_create_personal_access_tokens_table.php`

- [ ] **Step 1: 安装 Laravel Sanctum**

```bash
cd /var/www/html && composer require laravel/sanctum
```

- [ ] **Step 2: 发布 Sanctum 配置文件**

```bash
cd /var/www/html && php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

- [ ] **Step 3: 运行 Sanctum 迁移**

```bash
cd /var/www/html && php artisan migrate
```

## Task 6: 创建健康检查路由

**Files:**
- 修改: `/var/www/html/routes/api.php`

- [ ] **Step 1: 添加健康检查路由**

```bash
cd /var/www/html && cat > routes/api.php << 'EOF'
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// 健康检查路由
Route::get('/health', function () {
    return response()->json([
        'status' => 'healthy',
        'timestamp' => now()->toISOString(),
        'version' => config('app.version', '1.0.0')
    ]);
});
EOF
```

## Task 7: 测试健康检查路由

**Files:**
- 无

- [ ] **Step 1: 启动开发服务器**

```bash
cd /var/www/html && php artisan serve --host=0.0.0.0 --port=8000 &
```

- [ ] **Step 2: 测试健康检查路由**

```bash
curl http://localhost:8000/api/health
```

## Task 8: 权限和所有权设置

**Files:**
- 无

- [ ] **Step 1: 设置文件权限**

```bash
cd /var/www/html && chown -R www-data:www-data storage bootstrap/cache
chmod -R 755 storage bootstrap/cache
chmod -R 775 storage/logs
```

## Task 9: 提交代码到 Git

**Files:**
- 无 (Git 配置)

- [ ] **Step 1: 检查 Git 状态**

```bash
cd /var/www/html && git status
```

- [ ] **Step 2: 初始化 Git 仓库**

```bash
cd /var/www/html && git init
git config user.name "Your Name"
git config user.email "you@example.com"
git add .
git commit -m "Initial commit - Laravel 11 project with Sanctum authentication"
```
