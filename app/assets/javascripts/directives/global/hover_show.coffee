app = angular.module("hoverShow", [])

app.directive 'hoverShow', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    target = elem.find(attrs.target)
    elem.hover ->
      target.show()
    , ->
      target.hide()

