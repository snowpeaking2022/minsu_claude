# 博客模块设计文档

## 概述
为水云阁民宿网站添加日常博客功能，支持富文本编辑，包含后台管理和前端展示。

## 数据库设计

### posts 表
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | bigint | PK, auto_increment | 主键 |
| title | varchar(200) | NOT NULL | 标题 |
| summary | text | NULLABLE | 摘要 |
| content | longtext | NOT NULL | 富文本内容 |
| cover_image | varchar(500) | NULLABLE | 封面图路径 |
| is_published | boolean | DEFAULT false | 是否发布 |
| published_at | timestamp | NULLABLE | 发布时间 |
| created_at | timestamp | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| updated_at | timestamp | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | 更新时间 |

## 后端设计

### 1. 模型
- `App\Models\Post` - 文章模型
  - 包含 fillable 字段：title, summary, content, cover_image, is_published, published_at
  - Scope: `published()` - 筛选已发布文章
  - 自动处理 published_at：当 is_published 变为 true 时自动设置

### 2. 后台管理路由（admin）
```php
// routes/web.php 追加
Route::prefix('admin')->name('admin.')->group(function () {
    // ... 现有路由
    Route::resource('posts', App\Http\Controllers\Admin\PostController::class);
    Route::patch('posts/{post}/toggle-publish', [App\Http\Controllers\Admin\PostController::class, 'togglePublish'])
        ->name('posts.toggle-publish');
});
```

### 3. 后台管理控制器
- `App\Http\Controllers\Admin\PostController`
  - `index()` - 文章列表（分页 10 条/页，支持按发布状态筛选）
  - `create()` - 显示创建表单
  - `store(Request $request)` - 保存新文章，处理封面图上传
  - `show(Post $post)` - 显示单篇文章
  - `edit(Post $post)` - 显示编辑表单
  - `update(Request $request, Post $post)` - 更新文章
  - `destroy(Post $post)` - 删除文章
  - `togglePublish(Post $post)` - 切换发布/草稿状态

### 4. API 路由
```php
// routes/api.php 或 routes/web.php
Route::prefix('api/v1')->name('api.v1.')->group(function () {
    Route::get('/posts', [App\Http\Controllers\Api\V1\PostController::class, 'index']);
    Route::get('/posts/{id}', [App\Http\Controllers\Api\V1\PostController::class, 'show']);
});
```

### 5. API 控制器
- `App\Http\Controllers\Api\V1\PostController`
  - `index()` - 返回已发布文章列表（分页 10 条/页，按发布时间倒序）
  - `show($id)` - 返回单篇文章详情

### 6. API Resource
- `App\Http\Resources\PostResource` - 文章资源转换

### 7. 富文本编辑器
- 使用 TinyMCE 6
- 集成到创建/编辑表单
- 支持图片上传功能

### 8. 文件上传
- 封面图存储在 `storage/app/public/post-covers`
- 软链接到 `public/storage/post-covers`
- 富文本内图片存储在 `storage/app/public/post-content-images`

## 前端设计

### 1. 页面路由
- `/blog` - 博客列表页
- `/blog/{id}` - 博客详情页

### 2. 导航栏
- 在 `front/app.vue` 中添加"博客"链接

### 3. 页面组件

#### 博客列表页 (`pages/blog/index.vue`)
- 响应式网格布局展示文章卡片
- 分页组件
- 从 API 获取已发布文章
- 组件结构：
  - Page header（标题）
  - BlogCard 组件列表
  - Pagination

#### 博客详情页 (`pages/blog/[id].vue`)
- 封面图（顶部大横幅）
- 标题
- 发布时间
- 富文本内容（使用 v-html 渲染，注意 XSS 防护）
- 返回列表按钮

### 4. 基础组件

#### BlogCard.vue
- 封面图
- 标题
- 摘要
- 发布时间
- 点击跳转到详情页

#### BlogContent.vue
- 富文本内容渲染容器
- 样式美化（排版、图片自适应等）

### 5. State 管理
- `stores/blog.ts` - Pinia Store
  - posts: 文章列表
  - currentPost: 当前文章
  - fetchPosts(): 获取列表
  - fetchPost(id): 获取单篇

### 6. API 调用
- 使用 `useFetch` 或 Pinia actions
- 从后端 API 获取数据

### 7. 样式
- 与现有网站风格保持一致
- 紫色渐变主题（#667eea → #764ba2）
- 响应式设计

## 安全考虑
- XSS 防护：富文本内容渲染时使用 DOMPurify 或服务端过滤
- 文件上传验证：只允许图片类型，限制文件大小
- API 权限：后台接口需要管理员权限，公开接口只返回已发布文章

## 实现步骤
1. 创建数据库迁移和模型
2. 创建后台控制器和视图
3. 集成富文本编辑器
4. 创建 API 接口
5. 创建前端页面和组件
6. 测试功能
7. 部署
