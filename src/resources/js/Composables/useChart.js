// src/composables/useChart.js
import { Chart } from 'chart.js/auto'

export function useChart() {
  const instances = new Map()

  const renderChart = (canvasElement, config) => {
    if (!canvasElement) return

    const key = canvasElement.id || canvasElement

    // Destroi instância anterior se existir
    if (instances.has(key)) {
      instances.get(key).destroy()
    }

    const chart = new Chart(canvasElement.getContext('2d'), config)
    instances.set(key, chart)
  }

  const renderLineChart = (canvasElement, { labels, data, label }) => {
    const config = {
      type: 'line',
      data: {
        labels,
        datasets: [{
          label,
          data,
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
            labels: { font: { size: 16 } }
          }
        },
        scales: {
          y: { beginAtZero: true }
        }
      }
    }

    renderChart(canvasElement, config)
  }

  const renderBarChart = (canvasElement, { labels, data, label }) => {
    const config = {
      type: 'bar',
      data: {
        labels,
        datasets: [{
          label,
          data,
          backgroundColor: '#003366',
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            labels: { font: { size: 16 } }
          }
        },
        scales: {
          y: { beginAtZero: true }
        }
      }
    }

    renderChart(canvasElement, config)
  }

  const destroyCharts = () => {
    instances.forEach(chart => chart.destroy())
    instances.clear()
  }

  return { renderChart, renderLineChart, renderBarChart, destroyCharts }
}
