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

(->
  cal = undefined
  calendarDate = undefined
  d = undefined
  m = undefined
  y = undefined
  @setDraggableEvents = ->
    $("#events .external-event").each ->
      eventObject = undefined
      eventObject = title: $.trim($(this).text())
      $(this).data "eventObject", eventObject
      $(this).draggable
        zIndex: 999
        revert: true
        revertDuration: 0



  setDraggableEvents()
  calendarDate = new Date()
  d = calendarDate.getDate()
  m = calendarDate.getMonth()
  y = calendarDate.getFullYear()
  cal = $(".full-calendar-demo").fullCalendar(
    header:
      center: "title"
      left: "basicDay,basicWeek,month"
      right: "prev,today,next"

    buttonText:
      prev: "<span class=\"icon-chevron-left\"></span>"
      next: "<span class=\"icon-chevron-right\"></span>"
      today: "Today"
      basicDay: "Day"
      basicWeek: "Week"
      month: "Month"

    droppable: true
    editable: true
    selectable: true
    select: (start, end, allDay) ->
      bootbox.prompt "Event title", (title) ->
        if title isnt null
          cal.fullCalendar "renderEvent",
            title: title
            start: start
            end: end
            allDay: allDay
          , true
          cal.fullCalendar "unselect"


    eventClick: (calEvent, jsEvent, view) ->
      bootbox.dialog
        message: $("<form class='form'><label>Change event name</label></form><input id='new-event-title' class='form-control' type='text' value='" + calEvent.title + "' /> ")
        buttons:
          delete:
            label: "<i class='icon-trash'></i> Delete Event"
            className: "pull-left"
            callback: ->
              cal.fullCalendar "removeEvents", (ev) ->
                ev._id is calEvent._id


          success:
            label: "<i class='icon-save'></i> Save"
            className: "btn-success"
            callback: ->
              calEvent.title = $("#new-event-title").val()
              cal.fullCalendar "updateEvent", calEvent


    drop: (date, allDay) ->
      copiedEventObject = undefined
      eventClass = undefined
      originalEventObject = undefined
      originalEventObject = $(this).data("eventObject")
      originalEventObject.id = Math.floor(Math.random() * 99999)
      eventClass = $(this).attr("data-event-class")
      console.log originalEventObject
      copiedEventObject = $.extend({}, originalEventObject)
      copiedEventObject.start = date
      copiedEventObject.allDay = allDay
      copiedEventObject["className"] = [eventClass]  if eventClass
      $(".full-calendar-demo").fullCalendar "renderEvent", copiedEventObject, true
      $(this).remove()  if $("#calendar-remove-after-drop").is(":checked")

    events: [
      {
        id: "event1"
        title: "All Day Event"
        start: new Date(y, m, 1)
        className: "event-orange"
      }
      {
        id: "event2"
        title: "Long Event"
        start: new Date(y, m, d - 5)
        end: new Date(y, m, d - 2)
        className: "event-red"
      }
      {
        id: 999
        id: "event3"
        title: "Repeating Event"
        start: new Date(y, m, d - 3, 16, 0)
        allDay: false
        className: "event-blue"
      }
      {
        id: 999
        id: "event3"
        title: "Repeating Event"
        start: new Date(y, m, d + 4, 16, 0)
        allDay: false
        className: "event-green"
      }
      {
        id: "event4"
        title: "Meeting"
        start: new Date(y, m, d, 10, 30)
        allDay: false
        className: "event-orange"
      }
      {
        id: "event5"
        title: "Lunch"
        start: new Date(y, m, d, 12, 0)
        end: new Date(y, m, d, 14, 0)
        allDay: false
        className: "event-red"
      }
      {
        id: "event6"
        title: "Birthday Party"
        start: new Date(y, m, d + 1, 19, 0)
        end: new Date(y, m, d + 1, 22, 30)
        allDay: false
        className: "event-purple"
      }
    ]
  )
  return
).call this
$(".chat .new-message").on "submit", (e) ->
  chat = undefined
  date = undefined
  li = undefined
  message = undefined
  months = undefined
  reply = undefined
  scrollable = undefined
  sender = undefined
  timeago = undefined
  date = new Date()
  months = [
    "January"
    "February"
    "March"
    "April"
    "May"
    "June"
    "July"
    "August"
    "September"
    "October"
    "November"
    "December"
  ]
  chat = $(this).parents(".chat")
  message = $(this).find("#message_body").val()
  $(this).find("#message_body").val ""
  if message.length isnt 0
    li = chat.find("li.message").first().clone()
    li.find(".body").text message
    timeago = li.find(".timeago")
    timeago.removeClass "in"
    month = (date.getMonth() + 1)
    date_day = (date.getDate())
    timeago.attr "title", "" + (date.getFullYear()) + "-" + ((if month < 10 then "0" else "")) + month + "-" + ((if date_day < 10 then "0" else "")) + date_day + " " + (date.getHours()) + ":" + (date.getMinutes()) + ":" + (date.getSeconds()) + " +0200"
    timeago.text "" + months[date.getMonth()] + " " + (date.getDate()) + ", " + (date.getFullYear()) + " " + (date.getHours()) + ":" + (date.getMinutes())
    setTimeAgo timeago
    sender = li.find(".name").text().trim()
    chat.find("ul").append li
    scrollable = li.parents(".scrollable")
    $(scrollable).slimScroll scrollTo: scrollable.prop("scrollHeight") + "px"
    li.effect "highlight", {}, 500
    reply = scrollable.find("li").not(":contains('" + sender + "')").first().clone()
    setTimeout (->
      date = new Date()
      timeago = reply.find(".timeago")
      timeago.attr "title", "" + (date.getFullYear()) + "-" + ((if month < 10 then "0" else "")) + month + "-" + ((if date_day < 10 then "0" else "")) + date_day + " " + (date.getHours()) + ":" + (date.getMinutes()) + ":" + (date.getSeconds()) + " +0200"
      timeago.text "" + months[date.getMonth()] + " " + (date.getDate()) + ", " + (date.getFullYear()) + " " + (date.getHours()) + ":" + (date.getMinutes())
      setTimeAgo timeago
      scrollable.find("ul").append reply
      $(scrollable).slimScroll scrollTo: scrollable.prop("scrollHeight") + "px"
      reply.effect "highlight", {}, 500
    ), 1000
  e.preventDefault()

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
