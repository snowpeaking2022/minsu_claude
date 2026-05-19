<template>
  <section class="hero-section">
    <div class="hero-content">
      <h1 class="hero-title">
        水云阁 · 避暑胜地
      </h1>
      <p class="hero-subtitle">
        牛背梁脚下的自然天堂，夏季避暑首选
      </p>
      <div class="hero-actions">
        <NuxtLink to="/rooms" class="btn btn-primary">
          立即预订
        </NuxtLink>
        <NuxtLink to="/rooms" class="btn btn-secondary">
          探索房间
        </NuxtLink>
      </div>
    </div>
    <div class="hero-overlay"></div>
  </section>
</template>

<script setup lang="ts">
</script>

<style scoped>
.hero-section {
  position: relative;
  height: 70vh;
  min-height: 500px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  overflow: hidden;
}

.hero-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&h=800&fit=crop') center/cover;
  opacity: 0.3;
}

.hero-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.4);
  z-index: 1;
}

.hero-content {
  position: relative;
  z-index: 2;
  text-align: center;
  color: white;
  max-width: 800px;
  padding: 0 20px;
}

.hero-title {
  font-size: 3.5rem;
  font-weight: 700;
  margin-bottom: 20px;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
  animation: fadeInDown 0.8s ease-out;
}

.hero-subtitle {
  font-size: 1.3rem;
  margin-bottom: 40px;
  opacity: 0.95;
  line-height: 1.6;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
  animation: fadeInUp 0.8s ease-out;
}

.hero-actions {
  display: flex;
  gap: 20px;
  justify-content: center;
  animation: fadeIn 1s ease-out;
}

.btn {
  display: inline-block;
  padding: 15px 40px;
  font-size: 1.1rem;
  font-weight: 600;
  text-decoration: none;
  border-radius: 50px;
  transition: all 0.3s ease;
  border: 2px solid transparent;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.btn-primary {
  background: rgba(255, 255, 255, 0.95);
  color: #667eea;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.btn-primary:hover {
  background: white;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
}

.btn-secondary {
  background: transparent;
  color: white;
  border-color: white;
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.1);
  transform: translateY(-2px);
}

@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 2.5rem;
  }

  .hero-subtitle {
    font-size: 1.1rem;
  }

  .hero-actions {
    flex-direction: column;
    align-items: center;
  }

  .btn {
    width: 200px;
    text-align: center;
  }
}
</style>
