# 项目初始化与环境配置 - 执行计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 建立本地开发环境，初始化 Laravel 11 后端和 Nuxt 3 前端项目

**Architecture:** 采用前后端分离架构，后端使用 Laravel 11 + Sanctum 认证，前端使用 Nuxt 3 + Element Plus + Pinia 状态管理

**Tech Stack:**
- 后端: Laravel 11, PHP 8.2+, Composer
- 前端: Nuxt 3, Vue 3, Element Plus, Pinia
- 认证: Laravel Sanctum
- 工具: Git

---

## 任务1: 创建后端目录并初始化 Laravel 项目

**Files:**
- Create: `D:\workspace\testing\backend\` (目录)

- [ ] **Step 1: 创建后端目录**

```powershell
mkdir -p D:\workspace\testing\backend
cd D:\workspace\testing\backend
```

- [ ] **Step 2: 初始化 Laravel 11 项目**

```powershell
composer create-project laravel/laravel . --prefer-dist
```
预期输出: Laravel 11 项目文件将被创建

- [ ] **Step 3: 验证 Laravel 版本**

```powershell
cd D:\workspace\testing\backend
php artisan --version
```
预期输出: Laravel Framework 11.x.x

## 任务2: 配置 Laravel .env 文件

**Files:**
- Modify: `D:\workspace\testing\backend\.env`

- [ ] **Step 1: 复制 .env.example 为 .env**

```powershell
cd D:\workspace\testing\backend
Copy-Item .env.example .env
```

- [ ] **Step 2: 配置 .env 文件**

使用文本编辑器修改 `.env` 文件，设置以下配置：

```env
APP_NAME=水云阁民宿
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=shuiyunge
DB_USERNAME=shuiyunge_user
DB_PASSWORD=WaterCloud2026!

SESSION_DOMAIN=xiaohulu.cloud
SANCTUM_STATEFUL_DOMAINS=xiaohulu.cloud,api.xiaohulu.cloud

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
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
PUSHER_APP_CLUSTER="mt1"

VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
VITE_PUSHER_HOST="${PUSHER_HOST}"
VITE_PUSHER_PORT="${PUSHER_PORT}"
VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
```

## 任务3: 安装 Laravel Sanctum 认证

**Files:**
- Modify: `D:\workspace\testing\backend\composer.json`
- Create: `D:\workspace\testing\backend\config\sanctum.php`

- [ ] **Step 1: 安装 Sanctum 包**

```powershell
cd D:\workspace\testing\backend
composer require laravel/sanctum
```

- [ ] **Step 2: 发布 Sanctum 配置文件**

```powershell
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```
预期输出: 配置文件将被发布到 `config/sanctum.php`

## 任务4: 创建前端目录并初始化 Nuxt 3 项目

**Files:**
- Create: `D:\workspace\testing\front\` (目录)

- [ ] **Step 1: 创建前端目录**

```powershell
mkdir -p D:\workspace\testing\front
cd D:\workspace\testing\front
```

- [ ] **Step 2: 初始化 Nuxt 3 项目**

```powershell
npx nuxi@latest init .
```
按提示选择默认配置

- [ ] **Step 3: 验证 Nuxt 项目**

```powershell
cd D:\workspace\testing\front
ls -la
```
预期输出: Nuxt 3 项目文件将被创建

## 任务5: 安装前端依赖并配置 Nuxt

**Files:**
- Modify: `D:\workspace\testing\front\package.json`
- Modify: `D:\workspace\testing\front\nuxt.config.ts`

- [ ] **Step 1: 安装前端依赖**

```powershell
cd D:\workspace\testing\front
npm install element-plus @element-plus/icons-vue pinia @pinia/nuxt pinia-plugin-persistedstate
```

- [ ] **Step 2: 配置 nuxt.config.ts**

修改 `nuxt.config.ts` 文件：

```typescript
export default defineNuxtConfig({
  devtools: { enabled: true },
  modules: ['@pinia/nuxt'],
  css: ['element-plus/dist/index.css'],
  app: {
    head: {
      title: '水云阁民宿',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'description', content: '水云阁民宿管理系统' }
      ]
    }
  },
  pinia: {
    autoImports: [
      'defineStore',
      ['defineStore', 'definePiniaStore']
    ]
  }
})
```

## 任务6: 初始化 Git 仓库

**Files:**
- Create: `D:\workspace\testing\.gitignore`
- Create: `D:\workspace\testing\backend\.gitignore` (Laravel 默认已创建)
- Create: `D:\workspace\testing\front\.gitignore` (Nuxt 默认已创建)

- [ ] **Step 1: 创建根目录 .gitignore**

```powershell
cd D:\workspace\testing
Write-Output @"
# Dependencies
node_modules/
vendor/

# Build outputs
dist/
build/
.nuxt/
.output/
public/build/

# Environment files
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS files
.DS_Store
Thumbs.db

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Testing
coverage/
.nyc_output/

# Misc
.cache/
.temp/
"@ | Out-File -FilePath .gitignore -Encoding utf8
```

- [ ] **Step 2: 初始化 Git 仓库**

```powershell
cd D:\workspace\testing
git init
```

- [ ] **Step 3: 添加所有文件到暂存区**

```powershell
git add .
```

- [ ] **Step 4: 提交初始版本**

```powershell
git commit -m "Initial commit: 项目初始化完成"
```

---

## 自我检查

1. **规范覆盖:** 所有任务均有对应的实现步骤
2. **占位符扫描:** 无占位符内容
3. **类型一致性:** 所有文件路径和配置均一致

---

## 执行选项

**Plan complete and saved to `docs/superpowers/plans/2026-05-17-project-initialization.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - 我将调度子代理来执行任务

**2. Inline Execution** - 在当前会话中执行任务

**Which approach?**
