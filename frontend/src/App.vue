<script setup lang="ts">
const modules = [
  { name: '作品', description: '管理作品设定、题材、简介和写作风格' },
  { name: '章节', description: '维护章节草稿、摘要、顺序和版本' },
  { name: '人物', description: '生成并编辑角色动机、关系和口吻' },
  { name: '世界观', description: '沉淀地点、阵营、规则和时间线' },
  { name: 'AI 生成', description: '通过 SSE 边生成边显示大纲、续写和润色' },
  { name: '一致性', description: '检查前后剧情、人物和世界观矛盾' }
];
</script>

<template>
  <main class="workspace">
    <aside class="sidebar">
      <div class="brand">
        <span class="brand-mark">N</span>
        <div>
          <strong>NovelCraft</strong>
          <small>AI 小说创作助手</small>
        </div>
      </div>

      <nav class="nav-list" aria-label="主导航">
        <button v-for="item in modules" :key="item.name" type="button">
          {{ item.name }}
        </button>
      </nav>
    </aside>

    <section class="canvas">
      <header class="topbar">
        <div>
          <p>Workspace</p>
          <h1>创作控制台</h1>
        </div>
        <button type="button" class="primary-action">新建作品</button>
      </header>

      <section class="hero-panel">
        <div>
          <p class="eyebrow">MVP Skeleton</p>
          <h2>后端 API 与前端工作台已分层，下一步接入作品和章节 CRUD。</h2>
        </div>
        <div class="stream-card">
          <span>event: delta</span>
          <strong>正在生成章节续写...</strong>
          <p>文本将通过 SSE 增量进入编辑区，并在用户确认后保存为历史版本。</p>
        </div>
      </section>

      <section class="module-grid" aria-label="模块概览">
        <article v-for="item in modules" :key="item.name">
          <h3>{{ item.name }}</h3>
          <p>{{ item.description }}</p>
        </article>
      </section>
    </section>
  </main>
</template>
