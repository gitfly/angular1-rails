app = angular.module("inputVisible", [])

app.directive 'inputVisible', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    $scope.$watch ->
      return elem.is(':visible')
    , ->
      elem.focus()
      elem.select()
