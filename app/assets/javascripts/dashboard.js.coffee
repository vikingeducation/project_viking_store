# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  dayChart = $("#dayChart")
  $.get '/dashboard/orders_by_day', (data) ->
    days = data.map (item) -> item.day
    values = data.map (item) -> item.sum

    myChart = new Chart(dayChart,
    type: 'line'
    data:
      labels: days
      datasets: [ {
        label: 'Dollars Earned'
        data: values
        backgroundColor: "rgba(0,255,0, 0.2)"
      }

      ]
    options:
      scales:
        yAxes: [ { ticks: beginAtZero: true }]
      labels:
        userCallback: (label) ->
          ' $' + label.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
    )

  weekChart = $("#weekChart")
  $.get '/dashboard/orders_by_week', (data) ->
    weeks = data.map (item) -> item.week
    values = data.map (item) -> item.sum

    myChart = new Chart(weekChart,
    type: 'line'
    data:
      labels: weeks
      datasets: [ {
        label: 'Dollars Earned'
        data: values
        backgroundColor: "rgba(0,255,0, 0.2)"
      }

      ]
    options:
      scaleUse2Y: true
      scales:
        yAxes: [ { ticks: beginAtZero: true }]
    )
