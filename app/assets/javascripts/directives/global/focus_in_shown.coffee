app = angular.module("focusOnShown", [])

app.directive "focusOnShown", ->
  (scope, elem, attr) ->
    setTimeout (->
      elem[0].focus()
      return
    ), 100
    return
