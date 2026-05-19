<template>
  <Layout>
    <HeroSection />
    <FacilitySection />
    <section class="rooms-preview">
      <div class="container">
        <h2 class="section-title">精选房间</h2>
        <p class="section-subtitle">体验水云阁的温馨与舒适</p>
        <div class="rooms-grid">
          <RoomCard
            v-for="room in previewRooms"
            :key="room.id"
            :room="room"
            @book="handleBookRoom"
          />
        </div>
        <div class="view-more">
          <NuxtLink to="/rooms" class="btn btn-outline">查看全部房间</NuxtLink>
        </div>
      </div>
    </section>
  </Layout>
</template>

<script setup lang="ts">
import { useRoomStore } from '~/stores/room'

const roomStore = useRoomStore()

// 模拟房间数据
const previewRooms = ref([
  {
    id: '1',
    name: '山景大床房',
    status: 'available',
    available: true,
    images: ['https://images.unsplash.com/photo-1560185007-6e8f29d2cdc4?w=800&h=600&fit=crop'],
    rating: 4.9,
    room_type: {
      id: '1',
      name: '山景房',
      capacity: 2,
      base_price: 688,
      description: '面朝牛背梁，享受自然之美'
    }
  },
  {
    id: '2',
    name: '园景双床房',
    status: 'available',
    available: true,
    images: ['https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&h=600&fit=crop'],
    rating: 4.8,
    room_type: {
      id: '2',
      name: '园景房',
      capacity: 4,
      base_price: 788,
      description: '俯瞰园景，感受田园风光'
    }
  },
  {
    id: '3',
    name: '豪华套房',
    status: 'available',
    available: true,
    images: ['https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&h=600&fit=crop'],
    rating: 5.0,
    room_type: {
      id: '3',
      name: '套房',
      capacity: 6,
      base_price: 1288,
      description: '尊享空间，奢华体验'
    }
  }
])

const handleBookRoom = (room: any) => {
  navigateTo(`/rooms/${room.id}`)
}

// 页面加载时获取房间数据
onMounted(async () => {
  try {
    await roomStore.fetchRooms()
  } catch (error) {
    console.log('使用模拟数据')
  }
})
</script>

<style scoped>
.rooms-preview {
  padding: 80px 0;
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

.rooms-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
  margin-bottom: 40px;
}

.view-more {
  text-align: center;
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
}

.btn-outline {
  background: transparent;
  color: #667eea;
  border-color: #667eea;
}

.btn-outline:hover {
  background: #667eea;
  color: white;
}

@media (max-width: 768px) {
  .section-title {
    font-size: 2rem;
  }

  .rooms-grid {
    grid-template-columns: 1fr;
  }
}
</style>
