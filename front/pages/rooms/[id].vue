<template>
  <div class="room-detail-page">
      <div class="container">
        <!-- 房间图片 -->
        <div class="room-images">
          <div class="main-image">
            <img
              :src="room.images?.[0] || 'https://images.unsplash.com/photo-1560185007-6e8f29d2cdc4?w=1200&h=800&fit=crop'"
              :alt="room.name"
              class="main-img"
            >
          </div>
          <div class="thumbnail-images">
            <div
              v-for="(image, index) in room.images || defaultImages"
              :key="index"
              class="thumbnail-item"
            >
              <img
                :src="image"
                :alt="`${room.name} ${index + 1}`"
                class="thumbnail-img"
              >
            </div>
          </div>
        </div>

        <!-- 房间信息 -->
        <div class="room-info">
          <div class="room-main-info">
            <h1 class="room-name">{{ room.name }}</h1>
            <div class="room-badge">{{ room.room_type?.name }}</div>
            <div class="room-price">
              ¥{{ room.room_type?.base_price }}<span class="price-unit">/晚</span>
            </div>
          </div>

          <div class="room-details">
            <div class="detail-row">
              <div class="detail-item">
                <span>👥 {{ room.room_type?.capacity }}人入住</span>
              </div>
              <div class="detail-item">
                <span>⭐ 评分 {{ room.rating || '4.8' }}分</span>
              </div>
              <div class="detail-item">
                <span>📍 牛背梁景区</span>
              </div>
            </div>
          </div>

          <!-- 房间描述 -->
          <div class="room-description">
            <h3>房间描述</h3>
            <p>{{ room.room_type?.description || '享受宁静舒适的居住体验，感受大自然的美好。' }}</p>
          </div>

          <!-- 设施列表 -->
          <div class="room-facilities">
            <h3>房间设施</h3>
            <div class="facilities-list">
              <div class="facility-tag" v-for="(facility, index) in roomFacilities" :key="index">
                <span>{{ facility.name }}</span>
              </div>
            </div>
          </div>

          <!-- 预订表单 -->
          <div class="booking-form">
            <h3>立即预订</h3>
            <el-form :model="bookingForm" label-width="100px">
              <el-row :gutter="10">
                <el-col :span="12">
                  <el-form-item label="入住日期">
                    <el-date-picker
                      v-model="bookingForm.checkIn"
                      type="date"
                      placeholder="选择日期"
                      style="width: 100%"
                      :disabled-date="disabledDate"
                    />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="退房日期">
                    <el-date-picker
                      v-model="bookingForm.checkOut"
                      type="date"
                      placeholder="选择日期"
                      style="width: 100%"
                      :disabled-date="disabledDate"
                    />
                  </el-form-item>
                </el-col>
              </el-row>

              <el-row :gutter="10">
                <el-col :span="12">
                  <el-form-item label="入住人数">
                    <el-input-number
                      v-model="bookingForm.adults"
                      :min="1"
                      :max="room.room_type?.capacity || 6"
                      style="width: 100%"
                    />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="儿童人数">
                    <el-input-number
                      v-model="bookingForm.children"
                      :min="0"
                      :max="3"
                      style="width: 100%"
                    />
                  </el-form-item>
                </el-col>
              </el-row>

              <el-form-item label="姓名">
                <el-input v-model="bookingForm.guestName" placeholder="请输入姓名" />
              </el-form-item>

              <el-form-item label="电话">
                <el-input v-model="bookingForm.guestPhone" placeholder="请输入电话" />
              </el-form-item>

              <el-form-item label="邮箱">
                <el-input v-model="bookingForm.guestEmail" placeholder="请输入邮箱" />
              </el-form-item>

              <el-form-item label="特殊要求">
                <el-input
                  v-model="bookingForm.specialRequests"
                  type="textarea"
                  :rows="3"
                  placeholder="如有特殊要求，请在此填写"
                />
              </el-form-item>

              <el-form-item>
                <el-button
                  type="primary"
                  size="large"
                  @click="handleSubmit"
                  :loading="loading"
                  style="width: 100%"
                >
                  {{ loading ? '预订中...' : '立即预订' }}
                </el-button>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </div>
    </div>
</template>

<script setup lang="ts">
import { useRoomStore } from '~/stores/room'
import { useBookingStore } from '~/stores/booking'

const route = useRoute()
const roomStore = useRoomStore()
const bookingStore = useBookingStore()

const roomId = route.params.id as string

const room = ref<any>({})
const loading = ref(false)
const defaultImages = [
  'https://images.unsplash.com/photo-1560185007-6e8f29d2cdc4?w=1200&h=800&fit=crop',
  'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=1200&h=800&fit=crop',
  'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=1200&h=800&fit=crop'
]

const roomFacilities = ref([
  { name: '免费WiFi' },
  { name: '免费早餐' },
  { name: '24小时热水' },
  { name: '免费停车' },
  { name: '景区接送' }
])

// 初始化预订表单
const bookingForm = reactive({
  roomId: roomId,
  checkIn: '',
  checkOut: '',
  guestName: '',
  guestPhone: '',
  guestEmail: '',
  adults: 1,
  children: 0,
  specialRequests: ''
})

// 禁止选择过去的日期
const disabledDate = (time: Date) => {
  return time.getTime() < Date.now() - 24 * 60 * 60 * 1000
}

const handleSubmit = async () => {
  if (!bookingForm.checkIn || !bookingForm.checkOut) {
    ElMessage.warning('请选择入住和退房日期')
    return
  }

  if (!bookingForm.guestName || !bookingForm.guestPhone) {
    ElMessage.warning('请填写姓名和电话')
    return
  }

  loading.value = true

  try {
    await bookingStore.submitBooking()
    ElMessage.success('预订成功！')
    // 重置表单
    bookingForm.checkIn = ''
    bookingForm.checkOut = ''
    bookingForm.guestName = ''
    bookingForm.guestPhone = ''
    bookingForm.guestEmail = ''
    bookingForm.specialRequests = ''
    bookingForm.adults = 1
    bookingForm.children = 0
  } catch (error) {
    ElMessage.error('预订失败，请重试')
  } finally {
    loading.value = false
  }
}

// 获取房间详情
const fetchRoomDetail = async () => {
  try {
    // 这里可以调用 API 接口获取房间详情
    // 暂时使用模拟数据
    room.value = {
      id: roomId,
      name: '山景大床房',
      status: 'available',
      available: true,
      images: defaultImages,
      rating: 4.9,
      room_type: {
        id: '1',
        name: '山景房',
        capacity: 2,
        base_price: 688,
        description: '面朝牛背梁，享受自然之美'
      }
    }
  } catch (error) {
    console.error('获取房间详情失败:', error)
  }
}

onMounted(() => {
  fetchRoomDetail()
})
</script>

<style scoped>
.room-detail-page {
  padding: 40px 0;
}

.room-images {
  margin-bottom: 40px;
}

.main-image {
  margin-bottom: 20px;
}

.main-img {
  width: 100%;
  height: 500px;
  object-fit: cover;
  border-radius: 16px;
}

.thumbnail-images {
  display: flex;
  gap: 15px;
  overflow-x: auto;
}

.thumbnail-item {
  flex: 0 0 120px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
}

.thumbnail-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.thumbnail-item:hover .thumbnail-img {
  transform: scale(1.1);
}

.room-main-info {
  margin-bottom: 30px;
}

.room-name {
  font-size: 2.5rem;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 15px;
}

.room-badge {
  display: inline-block;
  background: #667eea;
  color: white;
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 0.9rem;
  margin-bottom: 15px;
}

.room-price {
  font-size: 2rem;
  font-weight: 700;
  color: #e74c3c;
}

.price-unit {
  font-size: 1rem;
  font-weight: 400;
  color: #95a5a6;
}

.room-details {
  margin-bottom: 30px;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 16px;
}

.detail-row {
  display: flex;
  gap: 30px;
  flex-wrap: wrap;
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.95rem;
  color: #7f8c8d;
}

.room-description,
.room-facilities {
  margin-bottom: 30px;
}

.room-description h3,
.room-facilities h3 {
  font-size: 1.3rem;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 15px;
}

.room-description p {
  color: #7f8c8d;
  line-height: 1.6;
}

.facilities-list {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
}

.facility-tag {
  display: flex;
  align-items: center;
  gap: 5px;
  background: #f8f9fa;
  padding: 10px 15px;
  border-radius: 20px;
  font-size: 0.9rem;
  color: #7f8c8d;
  transition: all 0.3s ease;
}

.facility-tag:hover {
  background: #667eea;
  color: white;
  transform: translateY(-2px);
}

.booking-form {
  background: #f8f9fa;
  padding: 30px;
  border-radius: 16px;
}

.booking-form h3 {
  font-size: 1.3rem;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 20px;
}

@media (max-width: 768px) {
  .main-img {
    height: 300px;
  }

  .room-name {
    font-size: 2rem;
  }

  .detail-row {
    flex-direction: column;
    gap: 15px;
  }

  .booking-form {
    padding: 20px;
  }
}
</style>
