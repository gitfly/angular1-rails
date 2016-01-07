app = angular.module("clickToSelect", [])

app.directive 'clickToSelect', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    elem.bind 'click', () ->
      $(attrs.target).selectText()
