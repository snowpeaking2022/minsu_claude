import { defineStore } from 'pinia'

export interface Post {
  id: number
  title: string
  summary: string | null
  content?: string
  cover_image: string | null
  is_published: boolean
  published_at: string | null
  created_at: string | null
}

interface PaginationMeta {
  current_page: number
  last_page: number
  per_page: number
  total: number
}

export const useBlogStore = defineStore('blog', () => {
  const posts = ref<Post[]>([])
  const currentPost = ref<Post | null>(null)
  const meta = ref<PaginationMeta>({
    current_page: 1,
    last_page: 1,
    per_page: 10,
    total: 0
  })
  const loading = ref(false)
  const error = ref('')

  const fetchPosts = async (page = 1, perPage = 10) => {
    loading.value = true
    error.value = ''
    try {
      const res: any = await $fetch('/api/v1/posts', {
        params: { page, per_page: perPage }
      })
      posts.value = res.data || []
      if (res.meta) {
        meta.value = {
          current_page: res.meta.current_page,
          last_page: res.meta.last_page,
          per_page: res.meta.per_page,
          total: res.meta.total
        }
      }
    } catch (err: any) {
      error.value = err.message || '加载文章失败'
      posts.value = []
    } finally {
      loading.value = false
    }
  }

  const fetchPost = async (id: number | string) => {
    loading.value = true
    error.value = ''
    currentPost.value = null
    try {
      const res: any = await $fetch(`/api/v1/posts/${id}`)
      currentPost.value = res.data || res
    } catch (err: any) {
      error.value = err.message || '加载文章详情失败'
    } finally {
      loading.value = false
    }
  }

  return {
    posts,
    currentPost,
    meta,
    loading,
    error,
    fetchPosts,
    fetchPost
  }
})
