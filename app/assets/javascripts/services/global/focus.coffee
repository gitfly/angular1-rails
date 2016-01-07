app = window.app

app.factory 'focus', ($timeout) ->
  (id) ->
    $timeout ->
      element = document.getElementById(id)
      if element
        element.focus()
      return
    return
