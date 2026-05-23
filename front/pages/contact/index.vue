<template>
  <div class="contact-page">
      <!-- Hero Section -->
      <div class="contact-hero">
        <div class="container">
          <h1>联系我们</h1>
          <p>期待您的到来，让我们一起创造美好的回忆</p>
        </div>
      </div>

      <section class="contact-content">
        <div class="container">
          <div class="contact-grid">
            <!-- 联系方式 -->
            <div class="contact-info">
              <h2>联系方式</h2>

              <div class="info-item" v-for="(item, index) in contactItems" :key="index">
                <div class="info-icon">
                  <span class="icon-letter">{{ item.title.charAt(0) }}</span>
                </div>
                <div class="info-content">
                  <h3>{{ item.title }}</h3>
                  <p v-for="(line, lineIndex) in item.lines" :key="lineIndex">{{ line }}</p>
                </div>
              </div>

              <!-- 地图占位 -->
              <div class="map-placeholder">
                <div class="map-content">
                  <p>📍 陕西省柞水县营盘镇牛背梁景区</p>
                </div>
              </div>
            </div>

            <!-- 联系表单 -->
            <div class="contact-form">
              <h2>给我们留言</h2>
              <el-form :model="form" label-width="100px">
                <el-form-item label="姓名">
                  <el-input v-model="form.name" placeholder="请输入您的姓名" />
                </el-form-item>

                <el-form-item label="电话">
                  <el-input v-model="form.phone" placeholder="请输入您的电话" />
                </el-form-item>

                <el-form-item label="邮箱">
                  <el-input v-model="form.email" placeholder="请输入您的邮箱" />
                </el-form-item>

                <el-form-item label="主题">
                  <el-input v-model="form.subject" placeholder="请输入主题" />
                </el-form-item>

                <el-form-item label="留言内容">
                  <el-input
                    v-model="form.message"
                    type="textarea"
                    :rows="5"
                    placeholder="请输入您的留言"
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
                    {{ loading ? '发送中...' : '发送留言' }}
                  </el-button>
                </el-form-item>
              </el-form>
            </div>
          </div>
        </div>
      </section>
    </div>
</template>

<script setup lang="ts">

const contactItems = ref([
  {
    title: '电话',
    lines: ['138-1234-5678', '0914-1234567']
  },
  {
    title: '邮箱',
    lines: ['info@shuiyunge.com', 'booking@shuiyunge.com']
  },
  {
    title: '地址',
    lines: ['陕西省柞水县营盘镇牛背梁景区']
  },
  {
    title: '营业时间',
    lines: ['24小时服务', '前台服务时间: 7:00 - 23:00']
  }
])

const form = reactive({
  name: '',
  phone: '',
  email: '',
  subject: '',
  message: ''
})

const loading = ref(false)

const handleSubmit = async () => {
  if (!form.name || !form.phone || !form.message) {
    ElMessage.warning('请填写必填项')
    return
  }

  loading.value = true

  try {
    // 这里可以调用 API 接口发送留言
    await new Promise(resolve => setTimeout(resolve, 1000))
    ElMessage.success('留言发送成功！我们会尽快回复您。')

    // 重置表单
    form.name = ''
    form.phone = ''
    form.email = ''
    form.subject = ''
    form.message = ''
  } catch (error) {
    ElMessage.error('发送失败，请重试')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.contact-hero {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 100px 0;
  text-align: center;
  color: white;
}

.contact-hero h1 {
  font-size: 3rem;
  font-weight: 700;
  margin-bottom: 15px;
}

.contact-hero p {
  font-size: 1.2rem;
  opacity: 0.9;
}

.contact-content {
  padding: 80px 0;
}

.contact-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 50px;
}

.contact-info h2,
.contact-form h2 {
  font-size: 2rem;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 30px;
}

.info-item {
  display: flex;
  gap: 20px;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 12px;
  margin-bottom: 20px;
}

.info-icon {
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  flex-shrink: 0;
}

.icon-letter {
  font-size: 1.5rem;
  font-weight: 700;
}

.info-content h3 {
  font-size: 1.1rem;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 8px;
}

.info-content p {
  color: #7f8c8d;
  margin: 4px 0;
}

.map-placeholder {
  width: 100%;
  height: 300px;
  background: #e9ecef;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 20px;
  border: 2px dashed #667eea;
}

.map-content {
  text-align: center;
  color: #667eea;
}

.map-content .el-icon {
  margin-bottom: 15px;
  opacity: 0.5;
}

.contact-form {
  background: #f8f9fa;
  padding: 40px;
  border-radius: 16px;
}

@media (max-width: 768px) {
  .contact-hero h1 {
    font-size: 2rem;
  }

  .contact-grid {
    grid-template-columns: 1fr;
  }

  .contact-form {
    padding: 20px;
  }
}
</style>
