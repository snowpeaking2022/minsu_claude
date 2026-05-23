<template>
  <NuxtLink :to="`/blog/${post.id}`" class="blog-card-link">
    <el-card class="blog-card" shadow="hover" body-style="padding: 0">
      <div class="blog-image-container">
        <img
          v-if="post.cover_image"
          :src="post.cover_image"
          :alt="post.title"
          class="blog-image"
          @error="handleImageError"
        >
        <div v-else class="blog-image blog-image-placeholder">
          <span>📝</span>
        </div>
      </div>
      <div class="blog-content">
        <h3 class="blog-title">{{ post.title }}</h3>
        <p v-if="post.summary" class="blog-summary">{{ post.summary }}</p>
        <div class="blog-meta">
          <span class="blog-date">📅 {{ formatDate(post.published_at) }}</span>
          <span class="blog-read-more">阅读全文 →</span>
        </div>
      </div>
    </el-card>
  </NuxtLink>
</template>

<script setup lang="ts">
import type { Post } from '~/stores/blog'

interface Props {
  post: Post
}

defineProps<Props>()

const formatDate = (dateStr: string | null) => {
  if (!dateStr) return ''
  const d = new Date(dateStr)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

const handleImageError = (event: Event) => {
  const target = event.target as HTMLImageElement
  target.style.display = 'none'
}
</script>

<style scoped>
.blog-card-link {
  text-decoration: none;
  color: inherit;
  display: block;
  height: 100%;
}

.blog-card {
  height: 100%;
  border: none;
  border-radius: 16px;
  overflow: hidden;
  transition: all 0.3s ease;
}

.blog-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.blog-image-container {
  position: relative;
  height: 200px;
  overflow: hidden;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.blog-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.blog-image-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 60px;
  color: white;
}

.blog-card:hover .blog-image {
  transform: scale(1.05);
}

.blog-content {
  padding: 20px;
}

.blog-title {
  margin: 0 0 12px 0;
  font-size: 1.2rem;
  font-weight: 600;
  color: #2c3e50;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  line-height: 1.4;
  min-height: 2.8em;
}

.blog-summary {
  color: #7f8c8d;
  font-size: 0.92rem;
  line-height: 1.6;
  margin-bottom: 16px;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  min-height: 4.8em;
}

.blog-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  border-top: 1px solid #f1f2f6;
  font-size: 0.88rem;
}

.blog-date {
  color: #95a5a6;
}

.blog-read-more {
  color: #667eea;
  font-weight: 500;
  transition: color 0.3s;
}

.blog-card:hover .blog-read-more {
  color: #764ba2;
}
</style>
