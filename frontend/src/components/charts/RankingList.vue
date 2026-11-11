<template>
  <div class="chart-card">
    <div class="card-header">Top 5 encuestas con más respuestas</div>
    <div class="card-body">
      <div v-if="rankingData.length === 0" class="text-center text-muted">
        Sin datos
      </div>
      <div v-for="item in rankingData" :key="item.name" class="ranking-item">
        <span class="rank-label">{{ item.name }}</span>
        <div style="flex:1; margin:0 6px;">
          <div class="rank-bar" :style="{ width: barWidth(item.responses) + '%' }"></div>
        </div>
        <span class="rank-value">{{ item.responses }}</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  items: { type: Array, default: () => [] },
});

const rankingData = computed(() => {
  return props.items.map(item => ({
    name: item.title || item.name || 'Sin título',
    responses: item.responses_count || item.responses || 0,
  }));
});

const maxResponses = computed(() => {
  const values = rankingData.value.map(i => i.responses);
  return values.length ? Math.max(...values, 1) : 1;
});

const MAX_BAR_WIDTH = 100; // porcentaje máximo de la barra

function barWidth(responses) {
  return (responses / maxResponses.value) * MAX_BAR_WIDTH;
}
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
  color: #235454;
}
.chart-card .card-body { padding: 6px 0 0 0; }

.ranking-item {
  display: flex;
  align-items: center;
  margin-bottom: 4px;
}
.ranking-item .rank-label {
  width: 300px;
  font-size: 0.70rem;
  font-weight: 500;
  color: #235454;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.ranking-item .rank-bar {
  height: 12px;
  background-color: #235454;
  border-radius: 3px;
  min-width: 3px;
  transition: width 0.3s;
}
.ranking-item .rank-value {
  font-size: 0.65rem;
  font-weight: 600;
  color: #235454;
  margin-left: 8px;
  min-width: 25px;
}
</style>