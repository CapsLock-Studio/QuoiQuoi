data = undefinedred = "#f34541"
orange = "#f8a326"
blue = "#00acec"
purple = "#9564e2"
green = "#49bf67"
randNumber = ->
  ((Math.floor(Math.random() * (1 + 50 - 20))) + 20) * 800

randSmallerNumber = ->
  ((Math.floor(Math.random() * (1 + 40 - 20))) + 10) * 200

if $("#stats-chart1").length isnt 0
  orders = [
    [
      1
      randNumber() - 10
    ]
    [
      2
      randNumber() - 10
    ]
    [
      3
      randNumber() - 10
    ]
    [
      4
      randNumber()
    ]
    [
      5
      randNumber()
    ]
    [
      6
      4 + randNumber()
    ]
    [
      7
      5 + randNumber()
    ]
    [
      8
      6 + randNumber()
    ]
    [
      9
      6 + randNumber()
    ]
    [
      10
      8 + randNumber()
    ]
    [
      11
      9 + randNumber()
    ]
    [
      12
      10 + randNumber()
    ]
    [
      13
      11 + randNumber()
    ]
    [
      14
      12 + randNumber()
    ]
    [
      15
      13 + randNumber()
    ]
    [
      16
      14 + randNumber()
    ]
    [
      17
      15 + randNumber()
    ]
    [
      18
      15 + randNumber()
    ]
    [
      19
      16 + randNumber()
    ]
    [
      20
      17 + randNumber()
    ]
    [
      21
      18 + randNumber()
    ]
    [
      22
      19 + randNumber()
    ]
    [
      23
      20 + randNumber()
    ]
    [
      24
      21 + randNumber()
    ]
    [
      25
      14 + randNumber()
    ]
    [
      26
      24 + randNumber()
    ]
    [
      27
      25 + randNumber()
    ]
    [
      28
      26 + randNumber()
    ]
    [
      29
      27 + randNumber()
    ]
    [
      30
      31 + randNumber()
    ]
  ]
  newOrders = [
    [
      1
      randSmallerNumber() - 10
    ]
    [
      2
      randSmallerNumber() - 10
    ]
    [
      3
      randSmallerNumber() - 10
    ]
    [
      4
      randSmallerNumber()
    ]
    [
      5
      randSmallerNumber()
    ]
    [
      6
      4 + randSmallerNumber()
    ]
    [
      7
      5 + randSmallerNumber()
    ]
    [
      8
      6 + randSmallerNumber()
    ]
    [
      9
      6 + randSmallerNumber()
    ]
    [
      10
      8 + randSmallerNumber()
    ]
    [
      11
      9 + randSmallerNumber()
    ]
    [
      12
      10 + randSmallerNumber()
    ]
    [
      13
      11 + randSmallerNumber()
    ]
    [
      14
      12 + randSmallerNumber()
    ]
    [
      15
      13 + randSmallerNumber()
    ]
    [
      16
      14 + randSmallerNumber()
    ]
    [
      17
      15 + randSmallerNumber()
    ]
    [
      18
      15 + randSmallerNumber()
    ]
    [
      19
      16 + randSmallerNumber()
    ]
    [
      20
      17 + randSmallerNumber()
    ]
    [
      21
      18 + randSmallerNumber()
    ]
    [
      22
      19 + randSmallerNumber()
    ]
    [
      23
      20 + randSmallerNumber()
    ]
    [
      24
      21 + randSmallerNumber()
    ]
    [
      25
      14 + randSmallerNumber()
    ]
    [
      26
      24 + randSmallerNumber()
    ]
    [
      27
      25 + randSmallerNumber()
    ]
    [
      28
      26 + randSmallerNumber()
    ]
    [
      29
      27 + randSmallerNumber()
    ]
    [
      30
      31 + randSmallerNumber()
    ]
  ]
  plot = $.plot($("#stats-chart1"), [
    {
      data: orders
      label: "Orders"
    }
    {
      data: newOrders
      label: "New rders"
    }
  ],
    series:
      lines:
        show: true
        lineWidth: 3

      shadowSize: 0

    legend:
      show: false

    grid:
      clickable: true
      hoverable: true
      borderWidth: 0
      tickColor: "#f4f7f9"

    colors: [
      "#00acec"
      "#f8a326"
    ]
  )
if $("#stats-chart2").length isnt 0
  orders = [
    [
      1
      randNumber() - 5
    ]
    [
      2
      randNumber() - 6
    ]
    [
      3
      randNumber() - 10
    ]
    [
      4
      randNumber()
    ]
    [
      5
      randNumber()
    ]
    [
      6
      4 + randNumber()
    ]
    [
      7
      10 + randNumber()
    ]
    [
      8
      12 + randNumber()
    ]
    [
      9
      6 + randNumber()
    ]
    [
      10
      8 + randNumber()
    ]
    [
      11
      9 + randNumber()
    ]
    [
      12
      10 + randNumber()
    ]
    [
      13
      11 + randNumber()
    ]
    [
      14
      12 + randNumber()
    ]
    [
      15
      3 + randNumber()
    ]
    [
      16
      14 + randNumber()
    ]
    [
      17
      14 + randNumber()
    ]
    [
      18
      15 + randNumber()
    ]
    [
      19
      16 + randNumber()
    ]
    [
      20
      17 + randNumber()
    ]
    [
      21
      18 + randNumber()
    ]
    [
      22
      19 + randNumber()
    ]
    [
      23
      20 + randNumber()
    ]
    [
      24
      21 + randNumber()
    ]
    [
      25
      14 + randNumber()
    ]
    [
      26
      24 + randNumber()
    ]
    [
      27
      25 + randNumber()
    ]
    [
      28
      26 + randNumber()
    ]
    [
      29
      27 + randNumber()
    ]
    [
      30
      31 + randNumber()
    ]
  ]
  newOrders = [
    [
      1
      randSmallerNumber() - 10
    ]
    [
      2
      randSmallerNumber() - 10
    ]
    [
      3
      randSmallerNumber() - 10
    ]
    [
      4
      randSmallerNumber()
    ]
    [
      5
      randSmallerNumber()
    ]
    [
      6
      4 + randSmallerNumber()
    ]
    [
      7
      5 + randSmallerNumber()
    ]
    [
      8
      6 + randSmallerNumber()
    ]
    [
      9
      6 + randSmallerNumber()
    ]
    [
      10
      8 + randSmallerNumber()
    ]
    [
      11
      9 + randSmallerNumber()
    ]
    [
      12
      10 + randSmallerNumber()
    ]
    [
      13
      11 + randSmallerNumber()
    ]
    [
      14
      12 + randSmallerNumber()
    ]
    [
      15
      13 + randSmallerNumber()
    ]
    [
      16
      14 + randSmallerNumber()
    ]
    [
      17
      15 + randSmallerNumber()
    ]
    [
      18
      15 + randSmallerNumber()
    ]
    [
      19
      16 + randSmallerNumber()
    ]
    [
      20
      17 + randSmallerNumber()
    ]
    [
      21
      18 + randSmallerNumber()
    ]
    [
      22
      19 + randSmallerNumber()
    ]
    [
      23
      20 + randSmallerNumber()
    ]
    [
      24
      21 + randSmallerNumber()
    ]
    [
      25
      14 + randSmallerNumber()
    ]
    [
      26
      24 + randSmallerNumber()
    ]
    [
      27
      25 + randSmallerNumber()
    ]
    [
      28
      26 + randSmallerNumber()
    ]
    [
      29
      27 + randSmallerNumber()
    ]
    [
      30
      31 + randSmallerNumber()
    ]
  ]
  plot = $.plot($("#stats-chart2"), [
    {
      data: orders
      label: "Orders"
    }
    {
      data: newOrders
      label: "New orders"
    }
  ],
    series:
      lines:
        show: true
        lineWidth: 3

      shadowSize: 0

    legend:
      show: false

    grid:
      clickable: true
      hoverable: true
      borderWidth: 0
      tickColor: "#f4f7f9"

    colors: [
      "#f34541"
      "#49bf67"
    ]
  )
  $("#stats-chart2").bind "plotclick", (event, pos, item) ->
    alert "Yeah! You just clicked on point " + item.dataIndex + " in " + item.series.label + "."  if item


$(".recent-activity .ok").on "click", (e) ->
  $(this).tooltip "hide"
  $(this).parents("li").fadeOut 500, ->
    $(this).remove()

  e.preventDefault()

$(".recent-activity .remove").on "click", (e) ->
  $(this).tooltip "hide"
  $(this).parents("li").fadeOut 500, ->
    $(this).remove()

  e.preventDefault()

$("#comments-more-activity").on "click", (e) ->
  $(this).button "loading"
  setTimeout (->
    list = undefined
    list = $("#comments-more-activity").parent().parent().find("ul")
    list.append list.find("li:not(:first)").clone().effect("highlight", {}, 500)
    $("#comments-more-activity").button "reset"
  ), 1000
  e.preventDefault()
  false

$("#users-more-activity").on "click", (e) ->
  $(this).button "loading"
  setTimeout (->
    list = undefined
    list = $("#users-more-activity").parent().parent().find("ul")
    list.append list.find("li:not(:first)").clone().effect("highlight", {}, 500)
    $("#users-more-activity").button "reset"
  ), 1000
  e.preventDefault()
  false


$(".todo-list .new-todo").on "submit", (e) ->
  li = undefined
  todo_name = undefined
  todo_name = $(this).find("#todo_name").val()
  $(this).find("#todo_name").val ""
  if todo_name.length isnt 0
    li = $(this).parents(".todo-list").find("li.item").first().clone()
    li.find("input[type='checkbox']").attr "checked", false
    li.removeClass("important").removeClass "done"
    li.find("label.todo span").text todo_name
    $(".todo-list ul").first().prepend li
    li.effect "highlight", {}, 500
  e.preventDefault()

$(".todo-list .actions .remove").on "click", (e) ->
  $(this).tooltip "hide"
  $(this).parents("li").fadeOut 500, ->
    $(this).remove()

  e.stopPropagation()
  e.preventDefault()
  false

$(".todo-list .actions .important").on "click", (e) ->
  $(this).parents("li").toggleClass "important"
  e.stopPropagation()
  e.preventDefault()
  false

$(".todo-list .check").on "click", ->
  checkbox = undefined
  checkbox = $(this).find("input[type='checkbox']")
  if checkbox.is(":checked")
    $(this).parents("li").addClass "done"
  else
    $(this).parents("li").removeClass "done"
