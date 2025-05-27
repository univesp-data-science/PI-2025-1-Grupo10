<template>
  <div>
    <Head title="Dashboard" />
    <h1 class="mb-8 text-3xl font-bold">Olá, {{ auth.user.first_name }}!</h1>

    <div class="flex items-center justify-end gap-2 mb-6">
      <label class="text-sm font-semibold">Selecione o período</label>
      <input type="date" v-model="dataInicio" class="px-2 py-1 border rounded-md" />
      <span class="font-semibold">—</span>
      <input type="date" v-model="dataFim" class="px-2 py-1 border rounded-md" />
    </div>

    <div class="grid grid-cols-1 md:grid-cols-5 gap-4 mb-6">
      <div class="bg-blue-100 p-4 rounded-lg">
        <p class="text-sm text-gray-600">Usuários/dia</p>
        <p class="text-2xl font-bold">{{ averages.avg_users }}</p>
      </div>
      <div class="bg-blue-100 p-4 rounded-lg">
        <p class="text-sm text-gray-600">Upload (GB)</p>
        <p class="text-2xl font-bold">{{ formatBytesToGB(averages.avg_input_octets) }}</p>
      </div>
      <div class="bg-blue-100 p-4 rounded-lg">
        <p class="text-sm text-gray-600">Download (GB)</p>
        <p class="text-2xl font-bold">{{ formatBytesToGB(averages.avg_output_octets) }}</p>
      </div>
      <div class="bg-blue-100 p-4 rounded-lg">
        <p class="text-sm text-gray-600">Tempo médio</p>
        <p class="text-2xl font-bold">{{ formatSecondsToMinutes(averages.avg_session_time) }} min</p>
      </div>
      <div class="bg-blue-100 p-4 rounded-lg">
        <p class="text-sm text-gray-600">Pico de Conexões</p>
        <p class="text-2xl font-bold">{{ peaks.peak_users }}</p>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div class="bg-white rounded-lg p-4 shadow">
        <h2 class="font-semibold mb-2">Tráfego por hora</h2>
        <div class="w-full bg-gray-100 aspect-[2/1] rounded-md">
          <canvas ref="canvasHora" class="w-full h-full"></canvas>
        </div>
      </div>

      <div class="bg-white rounded-lg p-4 shadow">
        <h2 class="font-semibold mb-2">Uso por dia da semana</h2>
        <div class="w-full bg-gray-100 aspect-[2/1] rounded-md">
          <canvas ref="canvasSemana" class="w-full h-full"></canvas>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { Inertia } from '@inertiajs/inertia'
import { Head } from '@inertiajs/vue3'
import Layout from '@/Shared/Layout.vue'
import { ref, watch, onMounted, onBeforeUnmount } from 'vue'
import { useChart } from '@/composables/useChart'

export default {
  components: {
    Head,
  },
  layout: Layout,
  props: {
    auth: Object,
    accessByHour: Array,
    accessByWeek: Array,
    averages: Object,
    peaks: Object,
    filters: Object 
  },
  data() {
    return {
      dataInicio: this.filters?.start_date?.substring(0, 10) || '',
      dataFim: this.filters?.end_date?.substring(0, 10) || ''
    }
  },
  watch: {
    dataInicio(val) {
      this.atualizarSeDatasPreenchidas()
    },
    dataFim(val) {
      this.atualizarSeDatasPreenchidas()
    }
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
    const dataInicio = ref('')
    const dataFim = ref('')

    const canvasHora = ref(null)
    const canvasSemana = ref(null)
    const diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom']
    const { renderLineChart, renderBarChart, destroyCharts } = useChart()

    onMounted(() => {
      renderLineChart(canvasHora.value,{
        labels: props.accessByHour.map(item => `${item.hour}h`),
        data: props.accessByHour.map(item => Number(item.total_users)),
        label: 'Usuários'
      })
      renderBarChart(canvasSemana.value, {
        labels: props.accessByWeek.map(item => diasSemana[item.week_day]),
        data: props.accessByWeek.map(item => Number(item.total_users)),
        label: 'Usuários'
      })
    })

    onBeforeUnmount(() => {
      destroyCharts()
    })

    return {
      canvasHora,
      canvasSemana
    }
  }
}
</script>
