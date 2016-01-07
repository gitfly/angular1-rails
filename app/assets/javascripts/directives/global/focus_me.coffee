app = angular.module("focusMe", [])

app.directive "focusMe", ->
  (scope, elem, attr) ->
    scope.$on attr.focusOn, (e) ->
      setTimeout (->
        elem[0].focus()
        return
      ), 100
      return
    return
