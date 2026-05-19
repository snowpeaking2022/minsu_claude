import { defineStore } from 'pinia'

export const useRoomStore = defineStore('room', () => {
  const rooms = ref([])
  const roomTypes = ref([])
  const loading = ref(false)
  const selectedRoom = ref(null)

  // 获取房间列表
  const fetchRooms = async () => {
    loading.value = true
    try {
      const res = await $fetch('/api/v1/rooms')
      rooms.value = res
    } catch (error) {
      console.error('Failed to fetch rooms:', error)
    } finally {
      loading.value = false
    }
  }

  // 获取房间类型
  const fetchRoomTypes = async () => {
    loading.value = true
    try {
      const res = await $fetch('/api/v1/room-types')
      roomTypes.value = res
    } catch (error) {
      console.error('Failed to fetch room types:', error)
    } finally {
      loading.value = false
    }
  }

  // 获取房间详情
  const fetchRoomDetail = async (id: string) => {
    loading.value = true
    try {
      const res = await $fetch(`/api/v1/rooms/${id}`)
      selectedRoom.value = res
    } catch (error) {
      console.error('Failed to fetch room detail:', error)
    } finally {
      loading.value = false
    }
  }

  return {
    rooms,
    roomTypes,
    loading,
    selectedRoom,
    fetchRooms,
    fetchRoomTypes,
    fetchRoomDetail
  }
})
