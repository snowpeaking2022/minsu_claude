<template>
  <div class="blog-content" v-html="content" />
</template>

<script setup lang="ts">
interface Props {
  content: string
}

defineProps<Props>()
</script>

<style scoped>
.blog-content {
  font-size: 1.05rem;
  line-height: 1.8;
  color: #2c3e50;
}

.blog-content :deep(h1),
.blog-content :deep(h2),
.blog-content :deep(h3),
.blog-content :deep(h4) {
  margin: 1.5em 0 0.6em;
  font-weight: 600;
  color: #2c3e50;
}

.blog-content :deep(h1) { font-size: 1.8rem; }
.blog-content :deep(h2) { font-size: 1.5rem; }
.blog-content :deep(h3) { font-size: 1.25rem; }
.blog-content :deep(h4) { font-size: 1.1rem; }

.blog-content :deep(p) {
  margin: 0 0 1.2em;
}

.blog-content :deep(img) {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
  margin: 1em 0;
  display: block;
}

.blog-content :deep(a) {
  color: #667eea;
  text-decoration: none;
  border-bottom: 1px solid rgba(102, 126, 234, 0.3);
}

.blog-content :deep(a:hover) {
  color: #764ba2;
  border-bottom-color: #764ba2;
}

.blog-content :deep(ul),
.blog-content :deep(ol) {
  margin: 1em 0;
  padding-left: 1.8em;
}

.blog-content :deep(li) {
  margin-bottom: 0.4em;
}

.blog-content :deep(blockquote) {
  margin: 1.2em 0;
  padding: 0.8em 1.2em;
  border-left: 4px solid #667eea;
  background: #f8f9fb;
  color: #555;
  border-radius: 0 6px 6px 0;
}

.blog-content :deep(code) {
  background: #f1f2f6;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
  font-size: 0.92em;
  color: #e74c3c;
}

.blog-content :deep(pre) {
  background: #2c3e50;
  color: #ecf0f1;
  padding: 1em;
  border-radius: 8px;
  overflow-x: auto;
  margin: 1.2em 0;
}

.blog-content :deep(pre code) {
  background: transparent;
  color: inherit;
  padding: 0;
}

.blog-content :deep(table) {
  width: 100%;
  border-collapse: collapse;
  margin: 1.2em 0;
}

.blog-content :deep(table th),
.blog-content :deep(table td) {
  border: 1px solid #e1e4e8;
  padding: 8px 12px;
  text-align: left;
}

.blog-content :deep(table th) {
  background: #f6f8fa;
  font-weight: 600;
}

.blog-content :deep(hr) {
  border: none;
  border-top: 1px solid #e1e4e8;
  margin: 2em 0;
}
</style>
