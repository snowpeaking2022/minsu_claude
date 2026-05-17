# 水云阁民宿网站 - 第一阶段实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 完成民宿网站核心功能上线，包括：
- 首页展示（英雄区、房型概览、设施介绍、客户评价）
- 房间列表/详情页（筛选、搜索、图片轮播）
- 在线预订系统（日期选择、预订提交）
- 后台管理（房间/预订管理、基本统计）

**Architecture:** 前后端分离，API-first架构
- 后端：Laravel 11 + MySQL 8.0
- 前端：Nuxt 3 + Element Plus
- 部署：腾讯云宝塔面板

**Tech Stack:**
- 后端：Laravel 11、Sanctum认证、Eloquent ORM、Redis缓存
- 前端：Nuxt 3、Element Plus、Pinia状态管理
- 数据库：MySQL 8.0、外键约束、索引优化
- 工具：Git、Postman、宝塔面板

---

## 文件结构规划

### 后端项目结构 (backend/)
```
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       └── V1/
│   │   │           ├── AuthController.php
│   │   │           ├── RoomController.php
│   │   │           ├── BookingController.php
│   │   │           └── ReviewController.php
│   │   ├── Requests/
│   │   ├── Middleware/
│   │   └── Resources/
│   ├── Models/
│   │   ├── User.php
│   │   ├── Room.php
│   │   ├── RoomType.php
│   │   ├── Booking.php
│   │   ├── Customer.php
│   │   └── Review.php
│   ├── Database/
│   │   ├── Migrations/
│   │   └── Seeders/
│   ├── Policies/
│   ├── Providers/
│   └── Http/
├── config/
├── public/
├── resources/
├── storage/
├── tests/
├── .env.example
├── composer.json
└── artisan
```

### 前端项目结构 (front/)
```
├── assets/
│   ├── css/
│   ├── fonts/
│   └── images/
├── components/
│   ├── common/
│   │   ├── HeroSection.vue
│   │   ├── RoomCard.vue
│   │   ├── FacilitySection.vue
│   │   └── ReviewSlider.vue
│   ├── rooms/
│   │   ├── RoomList.vue
│   │   ├── RoomDetail.vue
│   │   ├── PriceCalendar.vue
│   │   └── BookingForm.vue
│   └── admin/
├── pages/
│   ├── index.vue
│   ├── rooms/
│   │   ├── index.vue
│   │   └── [id].vue
│   ├── about.vue
│   ├── contact.vue
│   └── admin/
├── stores/
│   ├── useRoomStore.ts
│   ├── useBookingStore.ts
│   └── useAuthStore.ts
├── plugins/
├── composables/
├── nuxt.config.ts
├── tsconfig.json
└── package.json
```

---

## 任务分解

### 任务1：项目初始化与环境配置 (1天)

**目标：** 建立本地开发环境，初始化项目

**后端任务：**
- [ ] 1.1 在宝塔上创建 MySQL 数据库
  ```sql
  CREATE DATABASE shuiyunge DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE USER 'shuiyunge_user'@'%' IDENTIFIED BY 'YourStrongPassword!123';
  GRANT ALL PRIVILEGES ON shuiyunge.* TO 'shuiyunge_user'@'%';
  FLUSH PRIVILEGES;
  ```
- [ ] 1.2 初始化 Laravel 项目
  ```bash
  cd D:\workspace\testing
  mkdir backend
  cd backend
  composer create-project laravel/laravel . --prefer-dist
  ```
- [ ] 1.3 配置数据库连接和 Sanctum 认证
  ```env
  # .env
  DB_DATABASE=shuiyunge
  DB_USERNAME=shuiyunge_user
  DB_PASSWORD=YourStrongPassword!123
  SESSION_DOMAIN=xiaohulu.cloud
  SANCTUM_STATEFUL_DOMAINS=xiaohulu.cloud,api.xiaohulu.cloud
  ```

**前端任务：**
- [ ] 1.4 初始化 Nuxt 3 项目
  ```bash
  cd D:\workspace\testing
  mkdir front
  cd front
  npx nuxi@latest init .
  ```
- [ ] 1.5 安装依赖
  ```bash
  npm install element-plus @element-plus/icons-vue pinia @pinia/nuxt pinia-plugin-persistedstate
  ```

**Git任务：**
- [ ] 1.6 初始化 Git 仓库
  ```bash
  cd D:\workspace\testing
  git init
  git config user.name "YourName"
  git config user.email "your@email.com"
  git add .
  git commit -m "feat: 初始化项目"
  ```

---

### 任务2：数据库设计与模型创建 (2天)

**目标：** 建立核心数据模型和关系

**任务详情：**
- [ ] 2.1 生成数据库迁移文件
  ```bash
  # 房型
  php artisan make:model RoomType -m
  # 房间
  php artisan make:model Room -m
  # 预订
  php artisan make:model Booking -m
  # 客户
  php artisan make:model Customer -m
  # 评价
  php artisan make:model Review -m
  ```

- [ ] 2.2 编写迁移文件 (database/migrations/)
  ```php
  // 房间类型
  Schema::create('room_types', function (Blueprint $table) {
      $table->id();
      $table->string('name', 50);
      $table->text('description')->nullable();
      $table->unsignedTinyInteger('capacity')->default(2);
      $table->decimal('base_price', 10, 2);
      $table->json('amenities')->nullable();
      $table->unsignedTinyInteger('sort_order')->default(0);
      $table->timestamps();
  });

  // 房间
  Schema::create('rooms', function (Blueprint $table) {
      $table->id();
      $table->foreignId('room_type_id')->constrained()->cascadeOnDelete();
      $table->string('name', 100);
      $table->enum('status', ['available', 'maintenance'])->default('available');
      $table->timestamps();
  });

  // 预订
  Schema::create('bookings', function (Blueprint $table) {
      $table->id();
      $table->foreignId('customer_id')->nullable()->constrained()->nullOnDelete();
      $table->foreignId('room_id')->constrained()->cascadeOnDelete();
      $table->date('check_in');
      $table->date('check_out');
      $table->string('guest_name', 100);
      $table->string('guest_phone', 20);
      $table->string('guest_email')->nullable();
      $table->unsignedTinyInteger('adults')->default(1);
      $table->unsignedTinyInteger('children')->default(0);
      $table->text('special_requests')->nullable();
      $table->enum('status', ['pending', 'confirmed', 'cancelled', 'completed'])->default('pending');
      $table->decimal('total_price', 10, 2);
      $table->text('notes')->nullable();
      $table->timestamps();
      // 日期范围索引
      $table->index(['check_in', 'check_out']);
  });

  // 客户
  Schema::create('customers', function (Blueprint $table) {
      $table->id();
      $table->string('name', 100);
      $table->string('phone', 20)->unique();
      $table->string('email')->nullable();
      $table->json('tags')->nullable();
      $table->json('preferences')->nullable();
      $table->timestamps();
  });
  ```

- [ ] 2.3 运行迁移
  ```bash
  php artisan migrate
  ```

---

### 任务3：后端API开发 (4天)

**目标：** 完成核心API开发

#### 3.1 认证API
- [ ] 3.1.1 生成 AuthController
  ```bash
  php artisan make:controller Api/V1/AuthController
  ```

- [ ] 3.1.2 登录方法
  ```php
  use App\Models\User;
  use Illuminate\Http\Request;
  use Illuminate\Support\Facades\Auth;

  public function login(Request $request)
  {
      $request->validate([
          'email' => 'required|email',
          'password' => 'required|min:6',
      ]);

      if (Auth::attempt($request->only('email', 'password'))) {
          $user = Auth::user();
          $token = $user->createToken('api-token')->plainTextToken;
          return response()->json([
              'token' => $token,
              'user' => $user,
          ], 200);
      }

      return response()->json([
          'message' => '登录失败，邮箱或密码错误',
      ], 401);
  }
  ```

#### 3.2 房间API (RoomController.php)
- [ ] 3.2.1 获取房间列表
  ```php
  public function index()
  {
      $rooms = Room::with('roomType')
          ->where('status', 'available')
          ->get();
      return RoomResource::collection($rooms);
  }
  ```

- [ ] 3.2.2 获取房间详情
  ```php
  public function show(Room $room)
  {
      return new RoomResource($room->load('roomType'));
  }
  ```

#### 3.3 预订API (BookingController.php)
- [ ] 3.3.1 检查日期冲突
  ```php
  protected function checkAvailability(Room $room, $checkIn, $checkOut)
  {
      $conflicting = Booking::where('room_id', $room->id)
          ->whereIn('status', ['pending', 'confirmed'])
          ->where(function ($query) use ($checkIn, $checkOut) {
              $query->whereBetween('check_in', [$checkIn, $checkOut])
                    ->orWhereBetween('check_out', [$checkIn, $checkOut])
                    ->orWhere(function ($q) use ($checkIn, $checkOut) {
                        $q->where('check_in', '<', $checkIn)
                          ->where('check_out', '>', $checkOut);
                    });
          })
          ->count();
      return $conflicting === 0;
  }
  ```

- [ ] 3.3.2 创建预订
  ```php
  public function store(Request $request)
  {
      $request->validate([
          'room_id' => 'required|exists:rooms,id',
          'check_in' => 'required|date|after_or_equal:today',
          'check_out' => 'required|date|after:check_in',
          'guest_name' => 'required|string|max:100',
          'guest_phone' => 'required|string|max:20',
          'guest_email' => 'email',
          'adults' => 'required|integer|min:1',
          'children' => 'integer|min:0',
          'special_requests' => 'nullable|string',
      ]);

      $room = Room::find($request->room_id);
      if (!$this->checkAvailability($room, $request->check_in, $request->check_out)) {
          return response()->json(['message' => '房间在该日期已被预订'], 422);
      }

      // 创建或查找客户
      $customer = Customer::firstOrCreate(
          ['phone' => $request->guest_phone],
          ['name' => $request->guest_name, 'email' => $request->guest_email]
      );

      $booking = Booking::create([
          'customer_id' => $customer->id,
          'room_id' => $request->room_id,
          'check_in' => $request->check_in,
          'check_out' => $request->check_out,
          'guest_name' => $request->guest_name,
          'guest_phone' => $request->guest_phone,
          'guest_email' => $request->guest_email,
          'adults' => $request->adults,
          'children' => $request->children,
          'special_requests' => $request->special_requests,
          'total_price' => $this->calculatePrice($room, $request->check_in, $request->check_out),
      ]);

      return new BookingResource($booking);
  }
  ```

---

### 任务4：前端页面开发 (4天)

**目标：** 完成前台展示页面

#### 4.1 首页 (pages/index.vue)
- [ ] 4.1.1 英雄区组件
  ```vue
  <template>
    <div class="hero">
      <img src="/images/hero-bg.jpg" alt="水云阁民宿" class="hero-bg">
      <div class="hero-content">
        <h1>水云阁 · 避暑胜地</h1>
        <p>牛背梁脚下的自然天堂，夏季避暑首选</p>
        <div class="hero-actions">
          <el-button type="primary" size="large">立即预订</el-button>
          <el-button size="large">探索房间</el-button>
        </div>
      </div>
    </div>
  </template>
  ```

- [ ] 4.1.2 房间概览组件
  ```vue
  <template>
    <div class="room-overview">
      <h2>热门房型</h2>
      <div class="room-grid">
        <div v-for="room in hotRooms" :key="room.id" class="room-card">
          <el-card :body-style="{ padding: '0px' }">
            <img :src="room.images[0]" :alt="room.name" class="room-image">
            <div class="room-info">
              <h3>{{ room.name }}</h3>
              <p>{{ room.description }}</p>
              <div class="room-footer">
                <span class="price">¥{{ room.price }}/晚</span>
                <el-button type="primary" size="small">预订</el-button>
              </div>
            </div>
          </el-card>
        </div>
      </div>
    </div>
  </template>

  <script setup lang="ts">
  import { useRoomStore } from '~/stores/room'
  const roomStore = useRoomStore()
  const hotRooms = roomStore.hotRooms
  </script>
  ```

#### 4.2 房间详情页 (pages/rooms/[id].vue)
- [ ] 4.2.1 图片轮播
  ```vue
  <template>
    <el-carousel v-if="room" :interval="4000" type="card" height="400px">
      <el-carousel-item v-for="(img, index) in room.images" :key="index">
        <img :src="img" :alt="`${room.name}图片${index+1}`">
      </el-carousel-item>
    </el-carousel>
  </template>
  ```

- [ ] 4.2.2 价格日历
  ```vue
  <template>
    <el-calendar v-model="currentDate">
      <template #date-cell="{ data }">
        <div class="calendar-cell">
          {{ data.day.split('-').slice(2).join('-') }}
          <span v-if="isBooked(data.day)" class="booked"></span>
          <span v-if="data.isSelected" class="selected"></span>
        </div>
      </template>
    </el-calendar>
  </template>
  ```

---

### 任务5：后台管理开发 (3天)

**目标：** 完成基础管理功能

#### 5.1 管理员登录
- [ ] 5.1.1 登录页面
  ```vue
  <template>
    <div class="login-container">
      <el-form ref="loginForm" :model="loginForm" :rules="loginRules" label-width="70px">
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="loginForm.email" placeholder="请输入邮箱"></el-input>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input type="password" v-model="loginForm.password" placeholder="请输入密码"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleLogin" style="width: 100%">登录</el-button>
        </el-form-item>
      </el-form>
    </div>
  </template>
  ```

#### 5.2 预订管理
- [ ] 5.2.1 预订列表
  ```vue
  <template>
    <el-table :data="bookings" style="width: 100%">
      <el-table-column prop="id" label="编号"></el-table-column>
      <el-table-column prop="guest_name" label="客人姓名"></el-table-column>
      <el-table-column prop="guest_phone" label="电话"></el-table-column>
      <el-table-column prop="check_in" label="入住"></el-table-column>
      <el-table-column prop="check_out" label="退房"></el-table-column>
      <el-table-column prop="status" label="状态">
        <template #default="scope">
          <el-tag :type="getStatusType(scope.row.status)">{{ scope.row.status }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template #default="scope">
          <el-button size="small" @click="viewDetail(scope.row)">查看</el-button>
          <el-button size="small" type="primary" @click="confirmBooking(scope.row)" v-if="scope.row.status === 'pending'">确认</el-button>
          <el-button size="small" type="danger" @click="cancelBooking(scope.row)" v-if="scope.row.status !== 'cancelled' && scope.row.status !== 'completed'">取消</el-button>
        </template>
      </el-table-column>
    </el-table>
  </template>

  <script setup lang="ts">
  import { useBookingStore } from '~/stores/booking'
  const bookingStore = useBookingStore()
  const bookings = bookingStore.bookings
  </script>
  ```

---

### 任务6：测试与部署 (2天)

**目标：** 完成功能测试和部署上线

#### 6.1 功能测试
- [ ] 6.1.1 接口测试（使用 Postman）
  - 测试房间列表 API：GET `/api/v1/rooms`
  - 测试预订 API：POST `/api/v1/bookings`
  - 测试日期冲突检测

- [ ] 6.1.2 前端功能测试
  - 首页加载、导航
  - 房间列表筛选
  - 预订流程
  - 后台登录和管理功能

#### 6.2 部署上线
- [ ] 6.2.1 服务器环境检查
  ```bash
  # 检查 PHP 版本
  php -v
  # 检查 MySQL 连接
  mysql -u shuiyunge_user -pYourStrongPassword!123 shuiyunge -e "SELECT 1"
  ```

- [ ] 6.2.2 前端构建部署
  ```bash
  cd D:\workspace\testing\front
  npm run build
  # 将 .output 文件夹内容上传到 /www/wwwroot/xiaohulu/front
  ```

- [ ] 6.2.3 后端部署
  ```bash
  cd D:\workspace\testing\backend
  # 优化依赖
  composer install --optimize-autoloader --no-dev
  # 生成环境变量
  cp .env.example .env
  php artisan key:generate
  # 配置数据库
  # 运行迁移和填充数据
  php artisan migrate --seed
  # 启动队列
  php artisan queue:work --daemon
  ```

#### 6.3 域名解析
- [ ] 6.3.1 在腾讯云 DNS 解析中添加记录
  - `xiaohulu.cloud` -> 服务器IP
  - `api.xiaohulu.cloud` -> 服务器IP

- [ ] 6.3.2 在宝塔面板中配置网站
  - 创建网站：`xiaohulu.cloud`，根目录 `/www/wwwroot/xiaohulu/front`
  - 创建网站：`api.xiaohulu.cloud`，根目录 `/www/wwwroot/xiaohulu/backend/public`
  - 配置 SSL 证书（宝塔免费SSL）

---

## 测试数据填充

为了方便测试，我们需要填充一些测试数据。

**运行填充命令：**
```bash
php artisan db:seed --class=RoomTypeSeeder
php artisan db:seed --class=RoomSeeder
php artisan db:seed --class=ReviewSeeder
php artisan db:seed --class=UserSeeder
```

**Seeder 内容示例 (database/seeders/RoomSeeder.php)：**
```php
<?php

namespace Database\Seeders;

use App\Models\Room;
use App\Models\RoomType;
use Illuminate\Database\Seeder;

class RoomSeeder extends Seeder
{
    public function run()
    {
        $standardRoomType = RoomType::where('name', '标准间')->first();
        $kingRoomType = RoomType::where('name', '大床房')->first();

        Room::create([
            'room_type_id' => $standardRoomType->id,
            'name' => '山景标准间',
            'status' => 'available',
        ]);

        Room::create([
            'room_type_id' => $standardRoomType->id,
            'name' => '园景标准间',
            'status' => 'available',
        ]);

        Room::create([
            'room_type_id' => $kingRoomType->id,
            'name' => '豪华大床房',
            'status' => 'available',
        ]);

        Room::create([
            'room_type_id' => $kingRoomType->id,
            'name' => '家庭亲子房',
            'status' => 'available',
        ]);
    }
}
```

---

## 安全与性能优化

### 安全配置
- HTTPS 强制跳转
- Nginx 安全头配置
- 数据库连接使用 SSL（生产环境）

### 性能优化
- 图片压缩和懒加载
- 页面缓存和 CDN 加速
- 数据库查询优化（索引、避免 N+1 问题）

---

## 问题排查

### 常见问题

1. **前端无法连接 API**：检查 CORS 配置和域名解析
2. **预订冲突检测失效**：检查日期范围查询逻辑
3. **图片无法加载**：检查 public 目录权限

---

## 后续工作建议

### 第二阶段开发重点
1. 内容管理系统（博客、公告、图片库）
2. 客户管理系统（客户画像、反馈管理）
3. 数据统计和分析

### 第三阶段开发重点
1. 在线支付（支付宝/微信）
2. 日历房态管理
3. 会员/积分系统

---

## 执行方案

计划已完整创建，现在提供两种执行方式：

**方案1：分组件开发（推荐）**
- 每天完成一个功能模块
- 先做简单的（首页、房间列表），再做复杂的（预订）
- 每完成一个组件就测试一次

**方案2：分端开发**
- 后端先完成所有 API
- 前端一次性完成所有页面
- 最后整合测试

**建议使用方案1，因为它更符合敏捷开发理念，风险更低。**

计划已保存到：`D:\workspace\testing\docs\superpowers\plans\2026-05-17-phase1-overview.md`
