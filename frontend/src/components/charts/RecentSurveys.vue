<template>
  <div class="chart-card">
    <div class="card-header">Encuestas más recientes</div>
    <div class="card-body">
      <ul class="recent-list">
        <li v-for="survey in recentSurveys" :key="survey.title + survey.date">
          <span class="recent-title">{{ survey.title }}</span>
          <span class="recent-date">{{ survey.date }}</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  surveys: { type: Array, default: () => [] },
});

const recentSurveys = computed(() => props.surveys);
</script>

<style scoped>
.chart-card {
  background: #fff;
  border-radius: 7px;
  padding: 10px 12px 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.04);
  border: none;
  height: 100%;
}
.chart-card .card-header {
  background: transparent;
  border-bottom: 1px solid #eef2f8;
  padding: 0 0 6px 0;
  font-weight: 500;
  font-size: 0.75rem;
  color: #1e293b;
}
.chart-card .card-body { padding: 6px 0 0 0; }

.recent-list {
  list-style: none;
  padding: 0;
  margin: 0;
}
.recent-list li {
  display: flex;
  justify-content: space-between;
  padding: 4px 0;
  border-bottom: 1px solid #eef2f8;
  font-size: 0.65rem;
}
.recent-list li:last-child { border-bottom: none; }
.recent-list .recent-title { font-weight: 500; }
.recent-list .recent-date { color: #6c7a8d; }
</style>