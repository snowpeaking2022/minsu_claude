import { defineStore } from 'pinia'

export const useBookingStore = defineStore('booking', () => {
  const bookingForm = ref({
    roomId: '',
    checkIn: '',
    checkOut: '',
    guestName: '',
    guestPhone: '',
    guestEmail: '',
    adults: 1,
    children: 0,
    specialRequests: ''
  })

  const loading = ref(false)
  const success = ref(false)
  const error = ref('')

  // 提交预订
  const submitBooking = async () => {
    loading.value = true
    success.value = false
    error.value = ''

    try {
      await $fetch('/api/v1/bookings', {
        method: 'POST',
        body: bookingForm.value
      })
      success.value = true
      resetForm()
    } catch (err: any) {
      error.value = err.message || '预订失败，请重试'
    } finally {
      loading.value = false
    }
  }

  // 重置表单
  const resetForm = () => {
    bookingForm.value = {
      roomId: '',
      checkIn: '',
      checkOut: '',
      guestName: '',
      guestPhone: '',
      guestEmail: '',
      adults: 1,
      children: 0,
      specialRequests: ''
    }
  }

  return {
    bookingForm,
    loading,
    success,
    error,
    submitBooking,
    resetForm
  }
})
