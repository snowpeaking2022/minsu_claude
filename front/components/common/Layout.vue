<template>
  <div class="layout">
    <!-- 导航栏 -->
    <header class="header">
      <div class="container">
        <div class="logo">
          <h1>水云阁</h1>
        </div>
        <nav class="nav">
          <NuxtLink to="/" class="nav-link">首页</NuxtLink>
          <NuxtLink to="/rooms" class="nav-link">房间</NuxtLink>
          <NuxtLink to="/about" class="nav-link">关于</NuxtLink>
          <NuxtLink to="/contact" class="nav-link">联系</NuxtLink>
        </nav>
      </div>
    </header>

    <!-- 主内容区域 -->
    <main class="main">
      <slot />
    </main>

    <!-- 页脚 -->
    <footer class="footer">
      <div class="container">
        <div class="footer-content">
          <div class="footer-section">
            <h3>水云阁民宿</h3>
            <p>牛背梁脚下的自然天堂</p>
          </div>
          <div class="footer-section">
            <h4>联系我们</h4>
            <p>电话: 138-1234-5678</p>
            <p>邮箱: info@shuiyunge.com</p>
          </div>
          <div class="footer-section">
            <h4>地址</h4>
            <p>陕西省柞水县营盘镇牛背梁景区</p>
          </div>
        </div>
        <div class="footer-bottom">
          <p>&copy; 2026 水云阁民宿. All rights reserved.</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
.layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid #e0e0e0;
  position: sticky;
  top: 0;
  z-index: 1000;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.header .container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 70px;
}

.logo h1 {
  margin: 0;
  font-size: 24px;
  color: #2c3e50;
}

.nav {
  display: flex;
  gap: 30px;
}

.nav-link {
  color: #34495e;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s;
  position: relative;
}

.nav-link:hover {
  color: #3498db;
}

.nav-link::after {
  content: '';
  position: absolute;
  bottom: -5px;
  left: 0;
  width: 0;
  height: 2px;
  background: #3498db;
  transition: width 0.3s;
}

.nav-link:hover::after {
  width: 100%;
}

.main {
  flex: 1;
  padding: 40px 0;
}

.footer {
  background: #2c3e50;
  color: white;
  padding: 40px 0 20px;
  margin-top: auto;
}

.footer-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 40px;
  margin-bottom: 30px;
}

.footer-section h3,
.footer-section h4 {
  margin-top: 0;
}

.footer-section p {
  margin: 5px 0;
  opacity: 0.8;
}

.footer-bottom {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding-top: 20px;
  text-align: center;
}
</style>
