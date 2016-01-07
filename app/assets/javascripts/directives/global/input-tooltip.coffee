app = angular.module("inputTooltip", [])

app.directive 'inputTooltip', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    elem.attr('title', attrs.placeholder)
    elem.hover ->
      elem.tooltip('show')
    , ->
      elem.tooltip('hide')
