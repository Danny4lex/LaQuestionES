<template>
  <div class="chart-card">
    <div class="card-header">Participación por encuestas</div>
    <div class="card-body">
      <div class="chart-container">
        <canvas ref="canvasRef"></canvas>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue';
import Chart from 'chart.js/auto';

const props = defineProps({
  labels: { type: Array, default: () => [] },
  values: { type: Array, default: () => [] },
});

const canvasRef = ref(null);
let chartInstance = null;

function buildChart() {
  if (!canvasRef.value) return;

  if (chartInstance) {
    chartInstance.data.labels = props.labels;
    chartInstance.data.datasets[0].data = props.values;
    chartInstance.update();
    return;
  }

  chartInstance = new Chart(canvasRef.value, {
    type: 'bar',
    data: {
      labels: props.labels,
      datasets: [
        {
          label: 'Respuestas',
          data: props.values,
          backgroundColor: '#4880FF',
          borderRadius: 3,
          barPercentage: 0.5,
          categoryPercentage: 0.7
        }
      ]
    },
    options: {
      indexAxis: 'y',
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: {
        x: {
          beginAtZero: true,
          grid: { display: false },
          ticks: { font: { size: 10 } }
        },
        y: {
          grid: { display: false },
          ticks: { font: { size: 10, family: 'Poppins' } }
        }
      }
    }
  });
}

onMounted(buildChart);

watch(() => [props.labels, props.values], () => {
  if (chartInstance) {
    chartInstance.data.labels = props.labels;
    chartInstance.data.datasets[0].data = props.values;
    chartInstance.update();
  }
}, { deep: true });

onUnmounted(() => {
  if (chartInstance) {
    chartInstance.destroy();
  }
});
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
.chart-container { height: 120px; position: relative; }
</style>