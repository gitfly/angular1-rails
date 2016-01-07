app = angular.module("tooltip", [])

app.directive 'tooltip', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    elem.hover ->
      elem.tooltip('show')
    , ->
      elem.tooltip('hide')

