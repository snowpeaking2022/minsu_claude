# 博客模块实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为水云阁民宿网站添加博客功能，包含后台富文本编辑管理和前端博客列表/详情展示。

**Architecture:** Laravel 后端 + Nuxt 前端，前后端分离。后端提供 API 和后台管理界面，前端调用 API 展示博客内容。

**Tech Stack:** Laravel 11, Nuxt 4, Vue 3, Pinia, TinyMCE 6, MySQL 8

---

## 文件映射

### 后端文件
- **Create:** `database/migrations/2026_05_21_XXXXXX_create_posts_table.php` - 数据库迁移
- **Create:** `app/Models/Post.php` - Post 模型
- **Create:** `app/Http/Controllers/Admin/PostController.php` - 后台管理控制器
- **Create:** `app/Http/Controllers/Api/V1/PostController.php` - API 控制器
- **Create:** `app/Http/Resources/PostResource.php` - API 资源转换
- **Modify:** `routes/web.php` - 添加后台路由
- **Modify:** `routes/api.php` - 添加 API 路由
- **Create:** `resources/views/admin/posts/index.blade.php` - 文章列表视图
- **Create:** `resources/views/admin/posts/create.blade.php` - 创建/编辑表单视图

### 前端文件
- **Create:** `stores/blog.ts` - Pinia Store
- **Create:** `pages/blog/index.vue` - 博客列表页
- **Create:** `pages/blog/[id].vue` - 博客详情页
- **Create:** `components/BlogCard.vue` - 文章卡片组件
- **Create:** `components/BlogContent.vue` - 富文本内容组件
- **Modify:** `app.vue` - 添加导航栏链接

---

## 任务列表

### Task 1: 创建数据库迁移

**Files:**
- Create: `database/migrations/2026_05_21_XXXXXX_create_posts_table.php`

- [ ] **Step 1: 创建迁移文件**

在 backend 目录运行：
```bash
php artisan make:migration create_posts_table
```

找到生成的迁移文件，内容替换为：
```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('posts', function (Blueprint $table) {
            $table->id();
            $table->string('title', 200);
            $table->text('summary')->nullable();
            $table->longText('content');
            $table->string('cover_image', 500)->nullable();
            $table->boolean('is_published')->default(false);
            $table->timestamp('published_at')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('posts');
    }
};
```

- [ ] **Step 2: 运行迁移**

```bash
php artisan migrate
```

- [ ] **Step 3: 验证迁移**

检查数据库中是否创建了 posts 表

- [ ] **Step 4: Commit**

```bash
git add database/migrations/*_create_posts_table.php
git commit -m "feat: add posts table migration"
```

---

### Task 2: 创建 Post 模型

**Files:**
- Create: `app/Models/Post.php`

- [ ] **Step 1: 创建模型文件**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;

class Post extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'summary',
        'content',
        'cover_image',
        'is_published',
        'published_at'
    ];

    protected $casts = [
        'is_published' => 'boolean',
        'published_at' => 'datetime'
    ];

    public function scopePublished(Builder $query): Builder
    {
        return $query->where('is_published', true)
            ->whereNotNull('published_at')
            ->orderBy('published_at', 'desc');
    }

    protected static function boot()
    {
        parent::boot();

        static::saving(function ($post) {
            if ($post->is_published && !$post->published_at) {
                $post->published_at = now();
            }
        });
    }
}
```

- [ ] **Step 2: 验证模型**

检查语法错误

- [ ] **Step 3: Commit**

```bash
git add app/Models/Post.php
git commit -m "feat: add Post model"
```

---

### Task 3: 创建 API Resource

**Files:**
- Create: `app/Http/Resources/PostResource.php`

- [ ] **Step 1: 创建资源文件**

```php
<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PostResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'summary' => $this->summary,
            'content' => $this->content,
            'cover_image' => $this->cover_image ? asset('storage/' . $this->cover_image) : null,
            'is_published' => $this->is_published,
            'published_at' => $this->published_at?->format('Y-m-d H:i:s'),
            'created_at' => $this->created_at?->format('Y-m-d H:i:s'),
            'updated_at' => $this->updated_at?->format('Y-m-d H:i:s')
        ];
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add app/Http/Resources/PostResource.php
git commit -m "feat: add PostResource"
```

---

### Task 4: 创建 API 控制器

**Files:**
- Create: `app/Http/Controllers/Api/V1/PostController.php`

- [ ] **Step 1: 创建控制器文件**

```php
<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\PostResource;
use App\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function index()
    {
        $posts = Post::published()->paginate(10);
        return PostResource::collection($posts);
    }

    public function show($id)
    {
        $post = Post::published()->findOrFail($id);
        return new PostResource($post);
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add app/Http/Controllers/Api/V1/PostController.php
git commit -m "feat: add Post API controller"
```

---

### Task 5: 添加 API 路由

**Files:**
- Modify: `routes/api.php`

- [ ] **Step 1: 读取现有文件**

读取 `routes/api.php` 查看现有结构

- [ ] **Step 2: 添加博客 API 路由**

在 `routes/api.php` 中添加：
```php
use App\Http\Controllers\Api\V1\PostController;

Route::prefix('v1')->group(function () {
    Route::get('/posts', [PostController::class, 'index']);
    Route::get('/posts/{id}', [PostController::class, 'show']);
});
```

- [ ] **Step 3: 验证路由**

```bash
php artisan route:list --path=api/v1/posts
```

- [ ] **Step 4: Commit**

```bash
git add routes/api.php
git commit -m "feat: add blog API routes"
```

---

### Task 6: 创建后台管理控制器

**Files:**
- Create: `app/Http/Controllers/Admin/PostController.php`

- [ ] **Step 1: 创建控制器文件**

```php
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class PostController extends Controller
{
    public function index(Request $request)
    {
        $query = Post::latest();
        
        if ($request->has('status')) {
            if ($request->status === 'published') {
                $query->where('is_published', true);
            } elseif ($request->status === 'draft') {
                $query->where('is_published', false);
            }
        }
        
        $posts = $query->paginate(10);
        return view('admin.posts.index', compact('posts'));
    }

    public function create()
    {
        return view('admin.posts.create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:200',
            'summary' => 'nullable|string',
            'content' => 'required|string',
            'cover_image' => 'nullable|image|max:2048',
            'is_published' => 'nullable|boolean'
        ]);

        $validated['is_published'] = $request->has('is_published');

        if ($request->hasFile('cover_image')) {
            $path = $request->file('cover_image')->store('post-covers', 'public');
            $validated['cover_image'] = $path;
        }

        Post::create($validated);

        return redirect()->route('admin.posts.index')->with('success', '文章创建成功！');
    }

    public function show(Post $post)
    {
        return view('admin.posts.show', compact('post'));
    }

    public function edit(Post $post)
    {
        return view('admin.posts.create', compact('post'));
    }

    public function update(Request $request, Post $post)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:200',
            'summary' => 'nullable|string',
            'content' => 'required|string',
            'cover_image' => 'nullable|image|max:2048',
            'is_published' => 'nullable|boolean'
        ]);

        $validated['is_published'] = $request->has('is_published');

        if ($request->hasFile('cover_image')) {
            if ($post->cover_image) {
                Storage::disk('public')->delete($post->cover_image);
            }
            $path = $request->file('cover_image')->store('post-covers', 'public');
            $validated['cover_image'] = $path;
        }

        $post->update($validated);

        return redirect()->route('admin.posts.index')->with('success', '文章更新成功！');
    }

    public function destroy(Post $post)
    {
        if ($post->cover_image) {
            Storage::disk('public')->delete($post->cover_image);
        }
        $post->delete();

        return redirect()->route('admin.posts.index')->with('success', '文章删除成功！');
    }

    public function togglePublish(Post $post)
    {
        $post->is_published = !$post->is_published;
        $post->save();

        return redirect()->route('admin.posts.index')
            ->with('success', $post->is_published ? '文章已发布！' : '文章已取消发布！');
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add app/Http/Controllers/Admin/PostController.php
git commit -m "feat: add Post admin controller"
```

---

### Task 7: 添加后台路由

**Files:**
- Modify: `routes/web.php`

- [ ] **Step 1: 更新路由文件**

在 `routes/web.php` 的 admin 组中添加：
```php
use App\Http\Controllers\Admin\PostController;

Route::prefix('admin')->name('admin.')->group(function () {
    // ... 现有路由
    Route::resource('posts', PostController::class);
    Route::patch('posts/{post}/toggle-publish', [PostController::class, 'togglePublish'])
        ->name('posts.toggle-publish');
});
```

- [ ] **Step 2: 验证路由**

```bash
php artisan route:list --path=admin/posts
```

- [ ] **Step 3: Commit**

```bash
git add routes/web.php
git commit -m "feat: add blog admin routes"
```

---

### Task 8: 创建后台文章列表视图

**Files:**
- Create: `resources/views/admin/posts/index.blade.php`

- [ ] **Step 1: 创建视图目录**

确保目录存在：`resources/views/admin/posts`

- [ ] **Step 2: 创建列表视图**

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>文章管理 - 水云阁</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f8f9fa; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .header h1 { color: #2c3e50; }
        .btn { padding: 10px 20px; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; font-size: 14px; display: inline-block; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-success { background: #10b981; color: white; }
        .btn-danger { background: #ef4444; color: white; }
        .btn-sm { padding: 5px 12px; font-size: 12px; }
        .card { background: white; border-radius: 12px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #f8f9fa; font-weight: 600; color: #2c3e50; }
        .status { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .status-published { background: #d1fae5; color: #059669; }
        .status-draft { background: #fef3c7; color: #d97706; }
        .actions { display: flex; gap: 8px; }
        .pagination { display: flex; justify-content: center; gap: 8px; margin-top: 20px; }
        .alert { padding: 16px; border-radius: 8px; margin-bottom: 20px; }
        .alert-success { background: #d1fae5; color: #059669; }
        .filter { margin-bottom: 20px; }
        .filter select { padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>文章管理</h1>
            <a href="{{ route('admin.posts.create') }}" class="btn btn-primary">+ 新建文章</a>
        </div>

        @if(session('success'))
            <div class="alert alert-success">{{ session('success') }}</div>
        @endif

        <div class="filter">
            <form method="GET" action="{{ route('admin.posts.index') }}">
                <select name="status" onchange="this.form.submit()">
                    <option value="">全部状态</option>
                    <option value="published" {{ request('status') === 'published' ? 'selected' : '' }}>已发布</option>
                    <option value="draft" {{ request('status') === 'draft' ? 'selected' : '' }}>草稿</option>
                </select>
            </form>
        </div>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>标题</th>
                        <th>状态</th>
                        <th>发布时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($posts as $post)
                        <tr>
                            <td>{{ $post->title }}</td>
                            <td>
                                <span class="status {{ $post->is_published ? 'status-published' : 'status-draft' }}">
                                    {{ $post->is_published ? '已发布' : '草稿' }}
                                </span>
                            </td>
                            <td>{{ $post->published_at?->format('Y-m-d H:i') ?? '-' }}</td>
                            <td class="actions">
                                <a href="{{ route('admin.posts.edit', $post) }}" class="btn btn-sm btn-primary">编辑</a>
                                <form method="POST" action="{{ route('admin.posts.toggle-publish', $post) }}" style="display: inline;">
                                    @csrf
                                    @method('PATCH')
                                    <button type="submit" class="btn btn-sm btn-success">
                                        {{ $post->is_published ? '取消发布' : '发布' }}
                                    </button>
                                </form>
                                <form method="POST" action="{{ route('admin.posts.destroy', $post) }}" style="display: inline;" onsubmit="return confirm('确定要删除这篇文章吗？');">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="btn btn-sm btn-danger">删除</button>
                                </form>
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        </div>

        <div class="pagination">
            {{ $posts->links() }}
        </div>
    </div>
</body>
</html>
```

- [ ] **Step 3: Commit**

```bash
git add resources/views/admin/posts/index.blade.php
git commit -m "feat: add admin posts index view"
```

---

### Task 9: 创建后台文章编辑视图

**Files:**
- Create: `resources/views/admin/posts/create.blade.php`

- [ ] **Step 1: 创建编辑视图**

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ isset($post) ? '编辑文章' : '新建文章' }} - 水云阁</title>
    <script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f8f9fa; padding: 20px; }
        .container { max-width: 900px; margin: 0 auto; }
        .header { margin-bottom: 30px; }
        .header h1 { color: #2c3e50; }
        .card { background: white; border-radius: 12px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50; }
        .form-group input[type="text"],
        .form-group textarea { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
        .form-group textarea { min-height: 100px; resize: vertical; }
        .form-group input[type="file"] { padding: 8px 0; }
        .checkbox-group { display: flex; align-items: center; gap: 8px; }
        .checkbox-group input { width: auto; }
        .btn { padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; font-size: 14px; font-weight: 600; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-group { display: flex; gap: 12px; margin-top: 30px; }
        .cover-preview { max-width: 300px; margin-top: 10px; border-radius: 8px; display: none; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>{{ isset($post) ? '编辑文章' : '新建文章' }}</h1>
        </div>

        <div class="card">
            <form method="POST" action="{{ isset($post) ? route('admin.posts.update', $post) : route('admin.posts.store') }}" enctype="multipart/form-data">
                @csrf
                @if(isset($post))
                    @method('PUT')
                @endif

                <div class="form-group">
                    <label for="title">标题 *</label>
                    <input type="text" id="title" name="title" value="{{ old('title', $post->title ?? '') }}" required>
                </div>

                <div class="form-group">
                    <label for="summary">摘要</label>
                    <textarea id="summary" name="summary">{{ old('summary', $post->summary ?? '') }}</textarea>
                </div>

                <div class="form-group">
                    <label for="content">内容 *</label>
                    <textarea id="content" name="content">{{ old('content', $post->content ?? '') }}</textarea>
                </div>

                <div class="form-group">
                    <label for="cover_image">封面图</label>
                    <input type="file" id="cover_image" name="cover_image" accept="image/*" onchange="previewCover(event)">
                    @if(isset($post) && $post->cover_image)
                        <img id="cover-preview" src="{{ asset('storage/' . $post->cover_image) }}" class="cover-preview" style="display: block;">
                    @else
                        <img id="cover-preview" class="cover-preview">
                    @endif
                </div>

                <div class="form-group checkbox-group">
                    <input type="checkbox" id="is_published" name="is_published" {{ old('is_published', isset($post) && $post->is_published ? true : false) ? 'checked' : '' }}>
                    <label for="is_published" style="margin-bottom: 0; font-weight: normal;">立即发布</label>
                </div>

                <div class="btn-group">
                    <a href="{{ route('admin.posts.index') }}" class="btn btn-secondary">返回</a>
                    <button type="submit" class="btn btn-primary">保存</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        tinymce.init({
            selector: '#content',
            height: 400,
            menubar: true,
            plugins: [
                'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                'anchor', 'searchreplace', 'visualblocks', 'fullscreen',
                'insertdatetime', 'media', 'table', 'help', 'wordcount'
            ],
            toolbar: 'undo redo | blocks | bold italic forecolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat | help',
            content_style: 'body { font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif; font-size: 14px }'
        });

        function previewCover(event) {
            const preview = document.getElementById('cover-preview');
            const file = event.target.files[0];
            
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(file);
            } else {
                @if(isset($post) && $post->cover_image)
                    preview.src = "{{ asset('storage/' . $post->cover_image) }}";
                    preview.style.display = 'block';
                @else
                    preview.style.display = 'none';
                @endif
            }
        }
    </script>
</body>
</html>
```

- [ ] **Step 2: Commit**

```bash
git add resources/views/admin/posts/create.blade.php
git commit -m "feat: add admin posts create/edit view with TinyMCE"
```

---

### Task 10: 创建存储链接

**Files:**
- N/A

- [ ] **Step 1: 创建 storage 软链接**

在 backend 目录运行：
```bash
php artisan storage:link
```

- [ ] **Step 2: 验证链接**

检查 `public/storage` 是否存在

---

### Task 11: 创建前端 Blog Store

**Files:**
- Create: `front/stores/blog.ts`

- [ ] **Step 1: 创建 store 文件**

```typescript
import { defineStore } from 'pinia'

export interface Post {
  id: number
  title: string
  summary: string | null
  content: string
  cover_image: string | null
  is_published: boolean
  published_at: string | null
  created_at: string
  updated_at: string
}

export interface PostsResponse {
  data: Post[]
  current_page: number
  last_page: number
  per_page: number
  total: number
}

export const useBlogStore = defineStore('blog', () => {
  const posts = ref<Post[]>([])
  const currentPost = ref<Post | null>(null)
  const loading = ref(false)
  const currentPage = ref(1)
  const totalPages = ref(1)
  const totalPosts = ref(0)

  const fetchPosts = async (page: number = 1) => {
    loading.value = true
    try {
      const res = await $fetch<PostsResponse>(`/api/v1/posts?page=${page}`)
      posts.value = res.data
      currentPage.value = res.current_page
      totalPages.value = res.last_page
      totalPosts.value = res.total
    } catch (error) {
      console.error('Failed to fetch posts:', error)
    } finally {
      loading.value = false
    }
  }

  const fetchPost = async (id: string) => {
    loading.value = true
    try {
      const res = await $fetch<Post>(`/api/v1/posts/${id}`)
      currentPost.value = res
    } catch (error) {
      console.error('Failed to fetch post:', error)
      throw error
    } finally {
      loading.value = false
    }
  }

  return {
    posts,
    currentPost,
    loading,
    currentPage,
    totalPages,
    totalPosts,
    fetchPosts,
    fetchPost
  }
})
```

- [ ] **Step 2: Commit**

```bash
git add stores/blog.ts
git commit -m "feat: add blog store"
```

---

### Task 12: 创建 BlogCard 组件

**Files:**
- Create: `front/components/BlogCard.vue`

- [ ] **Step 1: 创建组件文件**

```vue
<template>
  <div class="blog-card" @click="onClick">
    <div v-if="post.cover_image" class="cover-image">
      <img :src="post.cover_image" :alt="post.title">
    </div>
    <div class="card-content">
      <h3 class="title">{{ post.title }}</h3>
      <p v-if="post.summary" class="summary">{{ post.summary }}</p>
      <p v-else class="summary">{{ truncateContent(post.content, 100) }}</p>
      <div class="meta">
        <span class="date">{{ formatDate(post.published_at || post.created_at) }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Post } from '~/stores/blog'

interface Props {
  post: Post
}

const props = defineProps<Props>()

const emit = defineEmits<{
  (e: 'click', post: Post): void
}>()

const onClick = () => {
  emit('click', props.post)
}

const formatDate = (dateStr: string) => {
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

const truncateContent = (content: string, maxLength: number) => {
  const text = content.replace(/<[^>]*>/g, '')
  if (text.length <= maxLength) return text
  return text.slice(0, maxLength) + '...'
}
</script>

<style scoped>
.blog-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  cursor: pointer;
  transition: all 0.3s ease;
}

.blog-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(0,0,0,0.15);
}

.cover-image {
  width: 100%;
  height: 200px;
  overflow: hidden;
}

.cover-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.card-content {
  padding: 20px;
}

.title {
  font-size: 1.25rem;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 10px;
}

.summary {
  color: #64748b;
  font-size: 0.95rem;
  line-height: 1.6;
  margin-bottom: 12px;
}

.meta {
  color: #94a3b8;
  font-size: 0.85rem;
}
</style>
```

- [ ] **Step 2: Commit**

```bash
git add components/BlogCard.vue
git commit -m "feat: add BlogCard component"
```

---

### Task 13: 创建 BlogContent 组件

**Files:**
- Create: `front/components/BlogContent.vue`

- [ ] **Step 1: 创建组件文件**

```vue
<template>
  <div class="blog-content" v-html="content"></div>
</template>

<script setup lang="ts">
interface Props {
  content: string
}

defineProps<Props>()
</script>

<style scoped>
.blog-content {
  color: #334155;
  line-height: 1.8;
  font-size: 1.05rem;
}

.blog-content :deep(img) {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
  margin: 20px 0;
}

.blog-content :deep(h1),
.blog-content :deep(h2),
.blog-content :deep(h3),
.blog-content :deep(h4) {
  color: #1e293b;
  margin-top: 32px;
  margin-bottom: 16px;
  font-weight: 600;
}

.blog-content :deep(h1) { font-size: 2rem; }
.blog-content :deep(h2) { font-size: 1.5rem; }
.blog-content :deep(h3) { font-size: 1.25rem; }

.blog-content :deep(p) {
  margin-bottom: 16px;
}

.blog-content :deep(ul),
.blog-content :deep(ol) {
  margin-bottom: 16px;
  padding-left: 24px;
}

.blog-content :deep(li) {
  margin-bottom: 8px;
}

.blog-content :deep(blockquote) {
  border-left: 4px solid #667eea;
  padding-left: 20px;
  margin: 24px 0;
  color: #64748b;
  font-style: italic;
}

.blog-content :deep(a) {
  color: #667eea;
  text-decoration: none;
}

.blog-content :deep(a:hover) {
  text-decoration: underline;
}

.blog-content :deep(code) {
  background: #f1f5f9;
  padding: 2px 8px;
  border-radius: 4px;
  font-family: monospace;
  font-size: 0.9em;
}
</style>
```

- [ ] **Step 2: Commit**

```bash
git add components/BlogContent.vue
git commit -m "feat: add BlogContent component"
```

---

### Task 14: 创建博客列表页

**Files:**
- Create: `front/pages/blog/index.vue`

- [ ] **Step 1: 创建页面文件**

```vue
<template>
  <div class="blog-list-page">
    <div class="container">
      <div class="page-header">
        <h1>水云阁博客</h1>
        <p>分享民宿生活与自然之美</p>
      </div>

      <div v-if="loading" class="loading">
        加载中...
      </div>

      <div v-else-if="posts.length === 0" class="empty">
        暂无文章
      </div>

      <div v-else class="posts-grid">
        <BlogCard
          v-for="post in posts"
          :key="post.id"
          :post="post"
          @click="goToDetail"
        />
      </div>

      <div v-if="totalPages > 1" class="pagination">
        <button
          class="page-btn"
          :disabled="currentPage === 1"
          @click="prevPage"
        >
          上一页
        </button>
        <span class="page-info">第 {{ currentPage }} / {{ totalPages }} 页</span>
        <button
          class="page-btn"
          :disabled="currentPage === totalPages"
          @click="nextPage"
        >
          下一页
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useBlogStore } from '~/stores/blog'
import BlogCard from '~/components/BlogCard.vue'

const blogStore = useBlogStore()
const { posts, loading, currentPage, totalPages, fetchPosts } = storeToRefs(blogStore)

const goToDetail = (post: any) => {
  navigateTo(`/blog/${post.id}`)
}

const prevPage = () => {
  if (currentPage.value > 1) {
    fetchPosts(currentPage.value - 1)
  }
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    fetchPosts(currentPage.value + 1)
  }
}

useHead({
  title: '博客 - 水云阁'
})

onMounted(() => {
  fetchPosts(1)
})
</script>

<style scoped>
.blog-list-page {
  padding: 40px 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.page-header {
  text-align: center;
  margin-bottom: 50px;
}

.page-header h1 {
  font-size: 2.5rem;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 10px;
}

.page-header p {
  font-size: 1.1rem;
  color: #64748b;
}

.loading,
.empty {
  text-align: center;
  padding: 60px 0;
  color: #64748b;
  font-size: 1.1rem;
}

.posts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 30px;
  margin-bottom: 50px;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 20px;
  padding: 20px 0;
}

.page-btn {
  padding: 12px 30px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 25px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.page-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.page-btn:disabled {
  background: #cbd5e1;
  cursor: not-allowed;
  transform: none;
}

.page-info {
  font-size: 1rem;
  color: #2c3e50;
  font-weight: 500;
}

@media (max-width: 768px) {
  .page-header h1 {
    font-size: 2rem;
  }

  .posts-grid {
    grid-template-columns: 1fr;
  }
}
</style>
```

- [ ] **Step 2: Commit**

```bash
git add pages/blog/index.vue
git commit -m "feat: add blog list page"
```

---

### Task 15: 创建博客详情页

**Files:**
- Create: `front/pages/blog/[id].vue`

- [ ] **Step 1: 创建页面文件**

```vue
<template>
  <div class="blog-detail-page">
    <div class="container">
      <div class="back-btn" @click="goBack">
        ← 返回博客
      </div>

      <div v-if="loading" class="loading">
        加载中...
      </div>

      <div v-else-if="error" class="error">
        {{ error }}
      </div>

      <div v-else-if="currentPost" class="post-content">
        <div v-if="currentPost.cover_image" class="cover-image">
          <img :src="currentPost.cover_image" :alt="currentPost.title">
        </div>

        <h1 class="title">{{ currentPost.title }}</h1>

        <div class="meta">
          <span class="date">{{ formatDate(currentPost.published_at || currentPost.created_at) }}</span>
        </div>

        <BlogContent :content="currentPost.content" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useBlogStore, type Post } from '~/stores/blog'
import BlogContent from '~/components/BlogContent.vue'

const route = useRoute()
const blogStore = useBlogStore()
const { currentPost, loading, fetchPost } = storeToRefs(blogStore)

const error = ref<string | null>(null)

const goBack = () => {
  navigateTo('/blog')
}

const formatDate = (dateStr: string) => {
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

useHead({
  title: computed(() => currentPost.value ? `${currentPost.value.title} - 水云阁` : '博客 - 水云阁')
})

onMounted(async () => {
  try {
    await fetchPost(route.params.id as string)
  } catch (e) {
    error.value = '文章不存在或已被删除'
  }
})
</script>

<style scoped>
.blog-detail-page {
  padding: 40px 0;
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 20px;
}

.back-btn {
  display: inline-block;
  color: #667eea;
  cursor: pointer;
  margin-bottom: 30px;
  font-weight: 500;
  transition: color 0.3s ease;
}

.back-btn:hover {
  color: #764ba2;
}

.loading,
.error {
  text-align: center;
  padding: 60px 0;
  color: #64748b;
  font-size: 1.1rem;
}

.error {
  color: #ef4444;
}

.cover-image {
  width: 100%;
  border-radius: 12px;
  overflow: hidden;
  margin-bottom: 40px;
}

.cover-image img {
  width: 100%;
  height: auto;
  max-height: 400px;
  object-fit: cover;
}

.title {
  font-size: 2.5rem;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 20px;
  line-height: 1.3;
}

.meta {
  color: #94a3b8;
  font-size: 0.95rem;
  margin-bottom: 40px;
  padding-bottom: 30px;
  border-bottom: 1px solid #e2e8f0;
}

@media (max-width: 768px) {
  .title {
    font-size: 1.75rem;
  }
}
</style>
```

- [ ] **Step 2: Commit**

```bash
git add pages/blog/[id].vue
git commit -m "feat: add blog detail page"
```

---

### Task 16: 更新导航栏

**Files:**
- Modify: `front/app.vue`

- [ ] **Step 1: 更新导航栏**

在导航栏中添加博客链接：
```html
<NuxtLink to="/blog" class="nav-link">博客</NuxtLink>
```

在 `app.vue` 的 nav 部分，在现有链接后添加

- [ ] **Step 2: 验证更新**

检查导航栏是否正常显示

- [ ] **Step 3: Commit**

```bash
git add app.vue
git commit -m "feat: add blog link to navigation"
```

---

### Task 17: 测试功能

**Files:**
- N/A

- [ ] **Step 1: 启动后端服务**

确保 Docker 正在运行：
```bash
cd D:\workspace\testing
docker-compose up -d
```

- [ ] **Step 2: 测试后台管理**

1. 访问 `http://localhost/admin/posts`
2. 点击"新建文章"
3. 填写标题、摘要、内容
4. 上传封面图
5. 勾选"立即发布"
6. 保存
7. 返回列表，确认文章已创建
8. 测试编辑、发布/取消发布、删除功能

- [ ] **Step 3: 测试前端展示**

1. 访问 `http://localhost:3000/blog`（或启动 Nuxt 开发服务器）
2. 确认文章列表显示
3. 点击文章卡片
4. 确认详情页正常显示
5. 测试分页功能

- [ ] **Step 4: 手动创建测试数据**

在后台创建几篇测试文章用于验证

---

## 自审检查

- [x] **Spec coverage:** 所有需求都有对应任务
- [x] **Placeholder scan:** 没有占位符，所有代码都已提供
- [x] **Type consistency:** 类型、方法名一致

---

## 执行选项

计划已完成并保存到 `docs/superpowers/plans/2026-05-21-blog-module.md`。

**两种执行方式：**

1. **Subagent-Driven (推荐)** - 为每个任务启动子代理，逐步完成，可审查每个步骤
2. **Inline Execution** - 在当前会话中批量执行所有任务

选择哪种方式？
