app = angular.module("selectOnFocus", [])

app.directive 'selectOnFocus', ->
  {
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.on 'focus', ->
        @select()
        return
      return
  }
