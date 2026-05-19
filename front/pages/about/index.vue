<template>
  <Layout>
    <div class="about-page">
      <!-- Hero Section -->
      <div class="about-hero">
        <div class="container">
          <h1>关于水云阁</h1>
          <p>牛背梁脚下的自然天堂</p>
        </div>
      </div>

      <!-- 民宿介绍 -->
      <section class="about-intro">
        <div class="container">
          <div class="intro-content">
            <div class="intro-text">
              <h2>我们的故事</h2>
              <p>
                水云阁民宿坐落于美丽的牛背梁景区脚下，是一处融合自然与现代的精品民宿。
                我们致力于为每一位客人提供舒适、温馨、贴近自然的居住体验。
              </p>
              <p>
                这里有清新的空气、优美的风景、贴心的服务，让您远离城市的喧嚣，
                享受大自然的宁静与美好。
              </p>
            </div>
            <div class="intro-image">
              <img
                src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&h=600&fit=crop"
                alt="水云阁民宿"
                class="intro-img"
              >
            </div>
          </div>
        </div>
      </section>

      <!-- 我们的特色 -->
      <section class="about-features">
        <div class="container">
          <h2 class="section-title">我们的特色</h2>
          <div class="features-grid">
            <div class="feature-item" v-for="(feature, index) in features" :key="index">
              <div class="feature-icon">
                <el-icon :size="48">{{ feature.icon }}</el-icon>
              </div>
              <h3 class="feature-title">{{ feature.title }}</h3>
              <p class="feature-description">{{ feature.description }}</p>
            </div>
          </div>
        </div>
      </section>

      <!-- 团队介绍 -->
      <section class="about-team">
        <div class="container">
          <h2 class="section-title">我们的团队</h2>
          <div class="team-grid">
            <div class="team-member" v-for="(member, index) in team" :key="index">
              <div class="member-avatar">
                <img :src="member.avatar" :alt="member.name" class="avatar-img">
              </div>
              <h3 class="member-name">{{ member.name }}</h3>
              <p class="member-role">{{ member.role }}</p>
              <p class="member-bio">{{ member.bio }}</p>
            </div>
          </div>
        </div>
      </section>
    </div>
  </Layout>
</template>

<script setup lang="ts">
import { Location, Star, Heart, Coffee, Sunset, ChatDotRound } from '@element-plus/icons-vue'

const features = ref([
  {
    title: '绝佳位置',
    description: '坐落于牛背梁景区脚下，交通便利，环境优美，是您休闲度假的理想选择。',
    icon: Location
  },
  {
    title: '贴心服务',
    description: '我们的团队提供24小时贴心服务，让您感受到家的温暖与舒适。',
    icon: Heart
  },
  {
    title: '品质保障',
    description: '严格的卫生标准，高品质的房间设施，为您提供安心舒适的居住体验。',
    icon: Star
  },
  {
    title: '美味餐饮',
    description: '提供当地特色美食，新鲜食材，让您品尝地道的农家风味。',
    icon: Coffee
  },
  {
    title: '美景环绕',
    description: '周围风景如画，可观日出日落，感受大自然的神奇与美丽。',
    icon: Sunset
  },
  {
    title: '交流互动',
    description: '定期举办各种活动，让客人之间交流互动，分享旅行的快乐。',
    icon: ChatDotRound
  }
])

const team = ref([
  {
    name: '张老板',
    role: '创始人',
    bio: '热爱自然，热爱生活，致力于为客人提供最好的住宿体验。',
    avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop'
  },
  {
    name: '李经理',
    role: '店长',
    bio: '多年酒店管理经验，用心服务每一位客人。',
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=200&fit=crop'
  },
  {
    name: '王师傅',
    role: '主厨',
    bio: '擅长当地特色菜，为客人提供美味可口的餐饮服务。',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop'
  }
])
</script>

<style scoped>
.about-hero {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 100px 0;
  text-align: center;
  color: white;
}

.about-hero h1 {
  font-size: 3rem;
  font-weight: 700;
  margin-bottom: 15px;
}

.about-hero p {
  font-size: 1.2rem;
  opacity: 0.9;
}

.about-intro {
  padding: 80px 0;
}

.intro-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 50px;
  align-items: center;
}

.intro-text h2 {
  font-size: 2.5rem;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 25px;
}

.intro-text p {
  color: #7f8c8d;
  line-height: 1.8;
  margin-bottom: 20px;
  font-size: 1.05rem;
}

.intro-img {
  width: 100%;
  height: 400px;
  object-fit: cover;
  border-radius: 16px;
}

.about-features {
  padding: 80px 0;
  background: #f8f9fa;
}

.section-title {
  text-align: center;
  font-size: 2.5rem;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 50px;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
}

.feature-item {
  text-align: center;
  padding: 40px 30px;
  background: white;
  border-radius: 16px;
  transition: all 0.3s ease;
}

.feature-item:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.feature-icon {
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 25px;
  color: white;
  transition: transform 0.3s ease;
}

.feature-item:hover .feature-icon {
  transform: scale(1.1);
}

.feature-title {
  font-size: 1.3rem;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 15px;
}

.feature-description {
  color: #7f8c8d;
  line-height: 1.6;
}

.about-team {
  padding: 80px 0;
}

.team-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 30px;
}

.team-member {
  text-align: center;
  padding: 40px 30px;
  background: white;
  border-radius: 16px;
  border: 1px solid #e9ecef;
  transition: all 0.3s ease;
}

.team-member:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.member-avatar {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  overflow: hidden;
  margin: 0 auto 25px;
  border: 4px solid #667eea;
}

.avatar-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.member-name {
  font-size: 1.3rem;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 8px;
}

.member-role {
  color: #667eea;
  font-weight: 500;
  margin-bottom: 15px;
}

.member-bio {
  color: #7f8c8d;
  line-height: 1.6;
}

@media (max-width: 768px) {
  .about-hero h1 {
    font-size: 2rem;
  }

  .intro-content {
    grid-template-columns: 1fr;
  }

  .intro-text h2 {
    font-size: 2rem;
  }

  .section-title {
    font-size: 2rem;
  }
}
</style>
