<template>
  <div class="blog-page">
    <div class="container">
      <div class="page-header">
        <h1>博客日志</h1>
        <p>记录山间日常、住客故事与水云阁的点滴</p>
      </div>

      <div v-if="loading && posts.length === 0" class="loading-state">
        <el-skeleton :rows="6" animated />
      </div>

      <div v-else-if="posts.length > 0" class="blog-grid">
        <BlogCard v-for="post in posts" :key="post.id" :post="post" />
      </div>

      <div v-else class="no-posts">
        <el-empty description="暂无博客文章" />
      </div>

      <div v-if="meta.last_page > 1" class="pagination">
        <button class="page-btn" :disabled="meta.current_page === 1" @click="changePage(meta.current_page - 1)">
          上一页
        </button>
        <span class="page-info">第 {{ meta.current_page }} / {{ meta.last_page }} 页</span>
        <button class="page-btn" :disabled="meta.current_page === meta.last_page" @click="changePage(meta.current_page + 1)">
          下一页
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { storeToRefs } from 'pinia'
import BlogCard from '~/components/blog/BlogCard.vue'
import { useBlogStore } from '~/stores/blog'

useHead({
  title: '博客日志 - 水云阁',
  meta: [{ name: 'description', content: '水云阁博客：记录山间日常、住客故事与生活感悟。' }]
})

const blogStore = useBlogStore()
const { posts, meta, loading } = storeToRefs(blogStore)

const changePage = async (page: number) => {
  if (page < 1 || page > meta.value.last_page) return
  await blogStore.fetchPosts(page, meta.value.per_page)
  if (process.client) {
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

await blogStore.fetchPosts(1, 9)
</script>

<style scoped>
.blog-page {
  padding: 40px 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
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

.blog-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 30px;
}

.loading-state {
  padding: 30px;
  background: white;
  border-radius: 12px;
}

.no-posts {
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

  .blog-grid {
    grid-template-columns: 1fr;
  }
}
</style>
