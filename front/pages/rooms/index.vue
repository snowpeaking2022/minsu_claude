<template>
  <div class="rooms-page">
      <div class="container">
        <div class="page-header">
          <h1>所有房间</h1>
          <p>选择您喜欢的房间，开始您的旅程</p>
        </div>

        <div class="rooms-grid">
          <RoomCard
            v-for="room in paginatedRooms"
            :key="room.id"
            :room="room"
            @book="handleBookRoom"
          />
        </div>

        <div v-if="rooms.length === 0" class="no-rooms">
          <el-empty description="暂无房间可用" />
        </div>

        <!-- 分页器 -->
        <div v-if="totalPages > 1" class="pagination">
          <button
            class="page-btn"
            :disabled="currentPage === 1"
            @click="currentPage--"
          >
            上一页
          </button>
          <span class="page-info">第 {{ currentPage }} / {{ totalPages }} 页</span>
          <button
            class="page-btn"
            :disabled="currentPage === totalPages"
            @click="currentPage++"
          >
            下一页
          </button>
        </div>
      </div>
    </div>
</template>

<script setup lang="ts">
import RoomCard from '~/components/room/RoomCard.vue'
import { useRoomStore } from '~/stores/room'

const roomStore = useRoomStore()
const pageSize = 6 // 每页6个房间
const currentPage = ref(1)

const rooms = computed(() => roomStore.rooms)

const totalPages = computed(() => Math.ceil(rooms.value.length / pageSize))

const paginatedRooms = computed(() => {
  const start = (currentPage.value - 1) * pageSize
  const end = start + pageSize
  return rooms.value.slice(start, end)
})

const handleBookRoom = (room: any) => {
  navigateTo(`/rooms/${room.id}`)
}

// 添加更多模拟房间数据
const allRooms = [
  { id: '1', name: '山景大床房', status: 'available', available: true, images: ['https://images.unsplash.com/photo-1560185007-6e8f29d2cdc4?w=800&h=600&fit=crop'], rating: 4.9, room_type: { id: '1', name: '山景房', capacity: 2, base_price: 688, description: '面朝牛背梁，享受自然之美' } },
  { id: '2', name: '园景双床房', status: 'available', available: true, images: ['https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&h=600&fit=crop'], rating: 4.8, room_type: { id: '2', name: '园景房', capacity: 4, base_price: 788, description: '俯瞰园景，感受田园风光' } },
  { id: '3', name: '豪华套房', status: 'available', available: true, images: ['https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&h=600&fit=crop'], rating: 5.0, room_type: { id: '3', name: '套房', capacity: 6, base_price: 1288, description: '尊享空间，奢华体验' } },
  { id: '4', name: '海景阳台房', status: 'available', available: true, images: ['https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800&h=600&fit=crop'], rating: 4.9, room_type: { id: '4', name: '海景房', capacity: 2, base_price: 888, description: '独立阳台，无敌海景' } },
  { id: '5', name: '家庭亲子房', status: 'available', available: true, images: ['https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=800&h=600&fit=crop'], rating: 4.7, room_type: { id: '5', name: '亲子房', capacity: 5, base_price: 988, description: '儿童友好，家庭首选' } },
  { id: '6', name: '温泉养生房', status: 'available', available: true, images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&h=600&fit=crop'], rating: 4.9, room_type: { id: '6', name: '温泉房', capacity: 2, base_price: 1088, description: '私人温泉，养生首选' } },
  { id: '7', name: '山间小木屋', status: 'available', available: true, images: ['https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800&h=600&fit=crop'], rating: 4.8, room_type: { id: '7', name: '小木屋', capacity: 3, base_price: 888, description: '独立木屋，亲近自然' } },
  { id: '8', name: '星空帐篷房', status: 'available', available: true, images: ['https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800&h=600&fit=crop'], rating: 4.6, room_type: { id: '8', name: '帐篷房', capacity: 2, base_price: 588, description: '夜观星空，独特体验' } },
  { id: '9', name: '复古中式房', status: 'available', available: true, images: ['https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=800&h=600&fit=crop'], rating: 4.8, room_type: { id: '9', name: '中式房', capacity: 2, base_price: 788, description: '中式风格，典雅舒适' } },
  { id: '10', name: '简约北欧房', status: 'available', available: true, images: ['https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=800&h=600&fit=crop'], rating: 4.7, room_type: { id: '10', name: '北欧房', capacity: 2, base_price: 688, description: '简约设计，清新自然' } }
]

onMounted(async () => {
  // 使用本地模拟数据
  roomStore.rooms = allRooms
})
</script>

<style scoped>
.rooms-page {
  padding: 40px 0;
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
  color: #7f8c8d;
}

.rooms-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
}

.no-rooms {
  text-align: center;
  padding: 80px 0;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 20px;
  margin-top: 50px;
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
  background: #ccc;
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

  .rooms-grid {
    grid-template-columns: 1fr;
  }
}
</style>
