<template>
  <div>
    <Head title="Evolução Mensal e Anual" />
    <h1 class="mb-8 text-3xl font-bold">Evolução Mensal e Anual</h1>

    <!-- Filtro de Período -->
     <!--
    <div class="flex items-center gap-2 mb-6">
      <label class="text-sm font-semibold">Selecione o período</label>
      <input type="date" class="px-2 py-1 border rounded-md" />
      <span class="font-semibold">—</span>
      <input type="date" class="px-2 py-1 border rounded-md" />
    </div>
    -->

    <!-- Gráfico de Barras por Semana -->
    <div class="bg-white rounded-lg p-4 shadow mb-6">
      <h2 class="font-semibold mb-2">Média Diária de Usuários por Mês</h2>
      <div class="w-full bg-gray-100 aspect-[2/1] rounded-md">
        <canvas ref="canvasUsuariosMensal" class="w-full h-full"></canvas>
      </div>
    </div>

    <!-- Gráfico de Linha Percentual -->
    <div class="bg-white rounded-lg p-4 shadow">
      <h2 class="font-semibold mb-2">Consumo Médio de Dados (GB) por Mês</h2>
      <div class="w-full bg-gray-100 aspect-[2/1] rounded-md">
        <canvas ref="canvasConsumoMensal" class="w-full h-full"></canvas>
      </div>
    </div>
  </div>
</template>

<script>
import { Head } from '@inertiajs/vue3'
import Layout from '@/Shared/Layout.vue'

import { ref, onMounted, onBeforeUnmount } from 'vue'
import { useChart } from '@/composables/useChart.js'

export default {
  components: {
    Head,
  },
  layout: Layout,
  props: {
    auth: Object,
    avgMonthUsers: Array,
    filters: Object 
  },
  methods: {
    atualizarSeDatasPreenchidas() {
      if (this.dataInicio && this.dataFim) {
        Inertia.get('/', {
          start_date: `${this.dataInicio} 00:00:00`,
          end_date: `${this.dataFim} 23:59:59`
        })
      }
    },
    formatBytesToGB(bytes) {
      if (!bytes) return '0'
      const gb = bytes / (1024 ** 3)
      return `${gb.toFixed(2)}`
    },
    formatSecondsToMinutes(seconds) {
      return seconds ? `${(seconds / 1000000).toFixed(0)}` : '0'
    }
  },
  setup(props) {
    const canvasUsuariosMensal = ref(null)
    const canvasConsumoMensal = ref(null)
    const { renderChart, destroyCharts } = useChart()
    const arrMonths = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez']

    function formatBytesToGB(bytes) {
      if (!bytes) return '0'
      return `${(bytes / 1024 ** 3).toFixed(2)}`
    }

    onMounted(() => {

      /*
      renderLineChart(canvasHora.value,{
        labels: props.accessByHour.map(item => `${item.hour}h`),
        data: props.accessByHour.map(item => Number(item.total_users)),
        label: 'Usuários'
      })
      */

      renderChart(canvasUsuariosMensal.value, {
        type: 'line',
        data: {
          labels:props.avgMonthUsers.map(item => `${item.computed_month}`),
          datasets: [{
            label: 'Usuários',
            data: props.avgMonthUsers.map(item => `${item.users/30}`),
            borderColor: '#37A3A3',
            backgroundColor: '#9AD8D8',
            fill: true,
            tension: 0.2
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              labels: { font: { size: 14 } }
            }
          },
          scales: {
            y: {
              beginAtZero: true
            }
          }
        }
      })

      renderChart(canvasConsumoMensal.value, {
        type: 'bar',
        data: {
          labels:props.avgMonthUsers.map(item => `${item.computed_month}`),
          datasets: [{
              label: 'Dados (GB)',
              data: props.avgMonthUsers.map(item => `${formatBytesToGB(item.acctoutputoctets)/30}`),
              borderWidth: 1,
              backgroundColor: '#004D99',
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              labels: { font: { size: 14 } }
            },
            tooltip: {
              callbacks: {
                //label: ctx => ctx.raw + '%'
              }
            }
          },
          scales: {
            y: {
              beginAtZero: true
            }
          }
        }
      })
    })

    onBeforeUnmount(() => {
      destroyCharts()
    })

    return {
      canvasConsumoMensal,
      canvasUsuariosMensal,
      formatBytesToGB
    }
  }
}
</script>
