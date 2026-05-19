<template>
  <el-card class="room-card" shadow="hover" body-style="padding: 0">
    <div class="room-image-container">
      <img
        :src="room.images?.[0] || 'https://images.unsplash.com/photo-1560185007-6e8f29d2cdc4?w=800&h=600&fit=crop'"
        :alt="room.name"
        class="room-image"
        @error="handleImageError"
      >
      <div class="room-badge">{{ room.room_type?.name }}</div>
    </div>
    <div class="room-content">
      <div class="room-header">
        <h3 class="room-name">{{ room.name }}</h3>
        <div class="room-price">
          ¥{{ room.room_type?.base_price }}<span class="price-unit">/晚</span>
        </div>
      </div>

      <p class="room-description" v-if="room.room_type?.description">
        {{ room.room_type.description }}
      </p>

      <div class="room-details">
        <div class="detail-item">
          <el-icon><House /></el-icon>
          <span>{{ room.room_type?.capacity }}人入住</span>
        </div>
        <div class="detail-item">
          <el-icon><Star /></el-icon>
          <span>评分 {{ room.rating || '4.8' }}分</span>
        </div>
        <div class="detail-item">
          <el-icon><Location /></el-icon>
          <span>牛背梁景区</span>
        </div>
      </div>

      <div class="room-footer">
        <el-button
          type="primary"
          size="default"
          @click="handleBook"
          :disabled="!room.available"
        >
          {{ room.available ? '立即预订' : '已预订' }}
        </el-button>
        <NuxtLink :to="`/rooms/${room.id}`" class="view-detail">
          查看详情 <el-icon><ArrowRight /></el-icon>
        </NuxtLink>
      </div>
    </div>
  </el-card>
</template>

<script setup lang="ts">
import { House, Star, Location, ArrowRight } from '@element-plus/icons-vue'

interface Room {
  id: string
  name: string
  status: string
  available?: boolean
  images?: string[]
  rating?: number
  room_type?: {
    id: string
    name: string
    capacity: number
    base_price: number
    description?: string
  }
}

interface Props {
  room: Room
}

const props = withDefaults(defineProps<Props>(), {
  room: () => ({})
})

const emit = defineEmits<{
  book: [room: Room]
}>()

const handleBook = () => {
  emit('book', props.room)
}

const handleImageError = (event: Event) => {
  const target = event.target as HTMLImageElement
  target.src = 'https://images.unsplash.com/photo-1560185007-6e8f29d2cdc4?w=800&h=600&fit=crop'
}
</script>

<style scoped>
.room-card {
  height: 100%;
  border: none;
  border-radius: 16px;
  overflow: hidden;
  transition: all 0.3s ease;
}

.room-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.room-image-container {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.room-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.room-card:hover .room-image {
  transform: scale(1.05);
}

.room-badge {
  position: absolute;
  top: 15px;
  left: 15px;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: 600;
  color: #667eea;
  z-index: 2;
}

.room-content {
  padding: 20px;
}

.room-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 15px;
}

.room-name {
  margin: 0;
  font-size: 1.3rem;
  font-weight: 600;
  color: #2c3e50;
}

.room-price {
  text-align: right;
}

.room-price {
  font-size: 1.4rem;
  font-weight: 700;
  color: #e74c3c;
}

.price-unit {
  font-size: 0.9rem;
  font-weight: 400;
  color: #95a5a6;
}

.room-description {
  color: #7f8c8d;
  font-size: 0.95rem;
  line-height: 1.6;
  margin-bottom: 15px;
  height: 60px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

.room-details {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
  padding-top: 15px;
  border-top: 1px solid #f1f2f6;
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 0.9rem;
  color: #7f8c8d;
}

.detail-item .el-icon {
  color: #667eea;
}

.room-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 15px;
  border-top: 1px solid #f1f2f6;
}

.room-footer .el-button {
  border-radius: 25px;
  padding: 8px 25px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
}

.view-detail {
  color: #667eea;
  text-decoration: none;
  font-size: 0.9rem;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: all 0.3s;
}

.view-detail:hover {
  color: #764ba2;
}

.view-detail:hover .el-icon {
  transform: translateX(3px);
}

@media (max-width: 768px) {
  .room-card {
    margin-bottom: 20px;
  }

  .room-content {
    padding: 15px;
  }

  .room-details {
    flex-direction: column;
    gap: 10px;
  }

  .room-footer {
    flex-direction: column;
    gap: 15px;
  }

  .room-footer .el-button {
    width: 100%;
  }

  .view-detail {
    width: 100%;
    text-align: center;
  }
}
</style>
