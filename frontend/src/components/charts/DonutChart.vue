<template>
  <div class="chart-card">
    <div class="card-header">Distribución por tipo</div>
    <div class="card-body">
      <div class="chart-container">
        <canvas ref="canvasRef"></canvas>
      </div>
      <div class="text-center text-muted small" style="font-size:0.6rem;">Públicas vs Privadas</div>
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
    type: 'doughnut',
    data: {
      labels: props.labels,
      datasets: [{
        data: props.values,
        backgroundColor: ['#2D52A7', '#4880FF'],
        borderColor: ['#2D52A7', '#4880FF'],
        borderWidth: 1
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: '70%',
      plugins: {
        legend: {
          position: 'bottom',
          labels: { font: { size: 12,family: 'Poppins' }  }
          
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
.chart-container { height: 300px; position: relative; }
</style>