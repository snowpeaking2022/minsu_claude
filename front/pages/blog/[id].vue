<template>
  <div class="blog-detail-page">
    <div class="container">
      <div v-if="loading" class="loading-state">
        <el-skeleton :rows="10" animated />
      </div>

      <div v-else-if="error || !currentPost" class="error-state">
        <el-empty :description="error || '文章不存在'">
          <NuxtLink to="/blog" class="back-link">返回博客列表</NuxtLink>
        </el-empty>
      </div>

      <article v-else class="blog-article">
        <NuxtLink to="/blog" class="back-link">← 返回博客列表</NuxtLink>

        <header class="article-header">
          <h1 class="article-title">{{ currentPost.title }}</h1>
          <div class="article-meta">
            <span>📅 发布于 {{ formatDate(currentPost.published_at) }}</span>
          </div>
          <p v-if="currentPost.summary" class="article-summary">
            {{ currentPost.summary }}
          </p>
        </header>

        <div v-if="currentPost.cover_image" class="article-cover">
          <img :src="currentPost.cover_image" :alt="currentPost.title">
        </div>

        <BlogContent v-if="currentPost.content" :content="currentPost.content" />

        <footer class="article-footer">
          <NuxtLink to="/blog" class="back-link">← 返回博客列表</NuxtLink>
        </footer>
      </article>
    </div>
  </div>
</template>

<script setup lang="ts">
import { storeToRefs } from 'pinia'
import BlogContent from '~/components/blog/BlogContent.vue'
import { useBlogStore } from '~/stores/blog'

const route = useRoute()
const blogStore = useBlogStore()
const { currentPost, loading, error } = storeToRefs(blogStore)

const formatDate = (dateStr: string | null) => {
  if (!dateStr) return ''
  const d = new Date(dateStr)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

await blogStore.fetchPost(route.params.id as string)

useHead(() => ({
  title: currentPost.value ? `${currentPost.value.title} - 水云阁博客` : '博客 - 水云阁',
  meta: [
    { name: 'description', content: currentPost.value?.summary || '水云阁博客文章' }
  ]
}))
</script>

<style scoped>
.blog-detail-page {
  padding: 40px 0;
  background: #fafbfc;
  min-height: 80vh;
}

.container {
  max-width: 820px;
  margin: 0 auto;
  padding: 0 20px;
}

.loading-state,
.error-state {
  background: white;
  border-radius: 16px;
  padding: 40px;
}

.blog-article {
  background: white;
  border-radius: 16px;
  padding: 40px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}

.back-link {
  display: inline-block;
  color: #667eea;
  text-decoration: none;
  font-size: 0.95rem;
  font-weight: 500;
  margin-bottom: 20px;
  transition: color 0.3s;
}

.back-link:hover {
  color: #764ba2;
}

.article-header {
  margin-bottom: 30px;
  padding-bottom: 24px;
  border-bottom: 1px solid #f1f2f6;
}

.article-title {
  font-size: 2.2rem;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 16px;
  line-height: 1.3;
}

.article-meta {
  color: #95a5a6;
  font-size: 0.95rem;
  margin-bottom: 16px;
}

.article-summary {
  color: #7f8c8d;
  font-size: 1.05rem;
  line-height: 1.7;
  font-style: italic;
  border-left: 3px solid #667eea;
  padding-left: 16px;
}

.article-cover {
  margin-bottom: 30px;
  border-radius: 12px;
  overflow: hidden;
}

.article-cover img {
  width: 100%;
  height: auto;
  display: block;
}

.article-footer {
  margin-top: 40px;
  padding-top: 24px;
  border-top: 1px solid #f1f2f6;
}

@media (max-width: 768px) {
  .blog-article {
    padding: 24px;
  }

  .article-title {
    font-size: 1.6rem;
  }
}
</style>
