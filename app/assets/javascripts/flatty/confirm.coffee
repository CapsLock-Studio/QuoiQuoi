$.rails.allowAction = (element) ->
  flag = false
  if !element.attr('data-confirm')
    flag = true
  else
    $.rails.showConfirmDialog(element)
  flag

$.rails.confirmed = (elemtent) ->
  elemtent.removeAttr('data-confirm')
  elemtent.trigger('click.rails')

$.rails.showConfirmDialog = (element) ->
  message = element.attr('data-confirm')
  bootbox.confirm(message, (result) ->
    confirmed = null
    if result
      confirmed = $.rails.confirmed(element)
    confirmed
  )