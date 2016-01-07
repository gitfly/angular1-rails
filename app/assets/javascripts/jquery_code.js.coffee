jQuery ->
  # $("a[rel~=popover], .has-popover").popover()
  # $("a[rel~=tooltip], .has-tooltip").tooltip()

  $('#search-btn').click ->
    btn = $(this)
    setTimeout ->
      $('#navbarInput-01').focus()
    , 100

  $.datepicker.setDefaults( $.datepicker.regional[ "zh-CN" ] )

  # $("#collapse-all ").click()
  $(document).keypress (e) ->
    if e.which == 13
      $(e.target).next().click()
    return
  

$(document).delegate '#sidebar li.logo span', 'click', ->
  main = $(this).parents('.main-content')
  if main.hasClass('wide-sidebar')
    main.removeClass('wide-sidebar').addClass('narrow-sidebar')
  else
    main.addClass('wide-sidebar').removeClass('narrow-sidebar')

jQuery.fn.selectText = ->
  `var range`
  doc = document
  element = @[0]
  if doc.body.createTextRange
    range = document.body.createTextRange()
    range.moveToElementText element
    range.select()
  else if window.getSelection
    selection = window.getSelection()
    range = document.createRange()
    range.selectNodeContents element
    selection.removeAllRanges()
    selection.addRange range
  return
