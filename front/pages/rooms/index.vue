<template>
  <Layout>
    <div class="rooms-page">
      <div class="container">
        <div class="page-header">
          <h1>所有房间</h1>
          <p>选择您喜欢的房间，开始您的旅程</p>
        </div>

        <div class="rooms-grid">
          <RoomCard
            v-for="room in rooms"
            :key="room.id"
            :room="room"
            @book="handleBookRoom"
          />
        </div>

        <div v-if="rooms.length === 0" class="no-rooms">
          <el-empty description="暂无房间可用" />
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup lang="ts">
import { useRoomStore } from '~/stores/room'

const roomStore = useRoomStore()

const rooms = computed(() => roomStore.rooms)

const handleBookRoom = (room: any) => {
  navigateTo(`/rooms/${room.id}`)
}

onMounted(async () => {
  await roomStore.fetchRooms()
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

@media (max-width: 768px) {
  .page-header h1 {
    font-size: 2rem;
  }

  .rooms-grid {
    grid-template-columns: 1fr;
  }
}
</style>
