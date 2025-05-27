<template>
  <div>
    <Head title="Relatório Semanal" />
    <h1 class="mb-8 text-3xl font-bold">Relatório Semanal</h1>

    <!-- Filtro de Período -->
    <div class="mb-6">
      <select class="px-6 py-2 border rounded-md">
        <option>Janeiro</option>
        <option>Fevereiro</option>
        <option>Março</option>
        <option>Abril</option>
        <option>Maio</option>
        <option>Junho</option>
        <option>Julho</option>
        <option>Agosto</option>
        <option>Setembro</option>
        <option>Outubro</option>
        <option>Novembro</option>
        <option>Dezembro</option>
      </select>
    </div>

    <!-- Gráfico Comparativo Semanal -->
    <div class="bg-white rounded-lg p-4 shadow mb-6">
      <h2 class="font-semibold mb-2">Uso por dia da semana</h2>
      <div class="w-full bg-gray-100 aspect-[2/1] rounded-md">
        <canvas ref="canvasUsoSemana" class="w-full h-full"></canvas>
      </div>
    </div>

    <!-- Variação Percentual Semana a Semana -->
    <div class="bg-white rounded-lg p-4 shadow mb-6">
      <h2 class="font-semibold mb-2">Variação Percentual Semana a Semana</h2>
      <div class="w-full bg-gray-100 aspect-[2/1] rounded-md">
        <canvas ref="canvasPercentual" class="w-full h-full"></canvas>
      </div>
    </div>

    <!-- Uso Médio por Dia da Semana ao Longo dos Meses -->
    <div class="bg-white rounded-lg p-4 shadow">
      <h2 class="font-semibold mb-2">Uso Médio por Dia da Semana ao Longo dos Meses</h2>
      <div class="w-full bg-gray-100 aspect-[2/1] rounded-md">
        <canvas ref="canvasUsoDiaSemanaMeses" class="w-full h-full"></canvas>
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
  setup() {
    const canvasUsoSemana = ref(null)
    const canvasPercentual = ref(null)
    const canvasUsoDiaSemanaMeses = ref(null)
    const { renderChart, destroyCharts } = useChart()

    onMounted(() => {
      // Gráfico Comparativo Semanal
      renderChart(canvasUsoSemana.value, {
        type: 'bar',
        data: {
          labels: ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'],
          datasets: [
            {
              label: 'Semana 1',
              data: [1900, 1300, 1950, 600, 2000, 1900, 2000],
              backgroundColor: '#5E40BE'
            },
            {
              label: 'Semana 2',
              data: [250, 1900, 650, 850, 1300, 1350, 2000],
              backgroundColor: '#B6A6E9'
            },
            {
              label: 'Semana 3',
              data: [600, 1250, 400, 150, 1900, 1900, 15],
              backgroundColor: '#21134D'
            },
            {
              label: 'Semana 4',
              data: [180, 850, 120, 1300, 950, 600, 750],
              backgroundColor: '#876FD4'
            }
          ]
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

      // Variação Percentual Semana a Semana
      renderChart(canvasPercentual.value, {
        type: 'line',
        data: {
          labels: ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'],
          datasets: [
            {
              label: '% de variação entre duas semanas',
              data: [8.3, 3.7, 3.6, 3.3, 3.1, -2.8, -5.9],
              borderColor: '#37A3A3',
              backgroundColor: '#9AD8D8',
              fill: true,
              tension: 0.3,
              //pointRadius: 4
            }
          ]
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
              beginAtZero: true,
              max: 12
            }
          }
        }
      })

      // Variação Percentual Semana a Semana
      renderChart(canvasUsoDiaSemanaMeses.value, {
        type: 'bar',
        data: {
          labels: ['Janeiro', 'Fevereiro', 'Março'],
          datasets: [
            {
              label: 'Segunda',
              data: [12, 19, 3],
              backgroundColor: '#004d99'
            },
            {
              label: 'Terça',
              data: [1, 2, 3],
              backgroundColor: '#6e4fa0'
            },
            {
              label: 'Quarta',
              data: [7, 6, 5],
              backgroundColor: '#a8509a'
            },
            {
              label: 'Quinta',
              data: [14, 5, 10],
              backgroundColor: '#d4588a'
            },
            {
              label: 'Sexta',
              data: [14, 5, 10],
              backgroundColor: '#f06c74'
            },
            {
              label: 'Sábado',
              data: [14, 5, 10],
              backgroundColor: '#fb8b60'
            },
            {
              label: 'Domingo',
              data: [14, 5, 10],
              backgroundColor: '#f8ae54'
            }
          ]
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
            x: { stacked: true},
            y: { stacked: true, beginAtZero: true }
          }
        }
      })
    })

    onBeforeUnmount(() => {
      destroyCharts()
    })

    return {
      canvasUsoSemana,
      canvasPercentual,
      canvasUsoDiaSemanaMeses,
    }
  }
}
</script>
