<template>
  <section class="facility-section">
    <div class="container">
      <h2 class="section-title">民宿设施</h2>
      <p class="section-subtitle">享受高品质的居住体验</p>

      <div class="facility-grid">
        <div class="facility-item" v-for="(facility, index) in facilities" :key="index">
          <div class="facility-icon">
            <el-icon :size="40">
              <component :is="facility.icon" />
            </el-icon>
          </div>
          <h3 class="facility-name">{{ facility.name }}</h3>
          <p class="facility-desc">{{ facility.description }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { Wifi, CoffeePot, WaterCup, Van, MapLocation, Camera, Star, Fire, Wind, Umbrella } from '@element-plus/icons-vue'

const facilities = [
  {
    name: '免费WiFi',
    description: '全屋高速网络覆盖',
    icon: Wifi
  },
  {
    name: '免费早餐',
    description: '新鲜营养早餐供应',
    icon: CoffeePot
  },
  {
    name: '24小时热水',
    description: '全天候热水供应',
    icon: WaterCup
  },
  {
    name: '免费停车',
    description: '宽敞停车场',
    icon: Van
  },
  {
    name: '景区接送',
    description: '提供景区接送服务',
    icon: MapLocation
  },
  {
    name: '观景露台',
    description: '山景/园景露台',
    icon: Camera
  },
  {
    name: '星级服务',
    description: '专业贴心服务',
    icon: Star
  },
  {
    name: '天然泉水',
    description: '山泉水供应',
    icon: WaterCup
  },
  {
    name: '中央空调',
    description: '四季恒温舒适',
    icon: Wind
  }
]
</script>

<style scoped>
.facility-section {
  padding: 80px 0;
  background: #f8f9fa;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.section-title {
  text-align: center;
  font-size: 2.5rem;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 15px;
}

.section-subtitle {
  text-align: center;
  font-size: 1.1rem;
  color: #7f8c8d;
  margin-bottom: 50px;
}

.facility-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 30px;
}

.facility-item {
  text-align: center;
  padding: 40px 30px;
  background: white;
  border-radius: 20px;
  transition: all 0.3s ease;
}

.facility-item:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.facility-icon {
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 25px;
  color: white;
  transition: transform 0.3s ease;
}

.facility-item:hover .facility-icon {
  transform: scale(1.1) rotate(5deg);
}

.facility-name {
  font-size: 1.2rem;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 10px;
}

.facility-desc {
  font-size: 0.95rem;
  color: #7f8c8d;
  line-height: 1.6;
}

@media (max-width: 768px) {
  .section-title {
    font-size: 2rem;
  }

  .facility-grid {
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 20px;
  }

  .facility-item {
    padding: 30px 20px;
  }

  .facility-icon {
    width: 60px;
    height: 60px;
    border-radius: 15px;
    margin-bottom: 20px;
  }

  .facility-name {
    font-size: 1rem;
  }

  .facility-desc {
    font-size: 0.85rem;
  }
}
</style>
