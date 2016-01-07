app = angular.module("ngSelect2", [])

app.directive 'ngSelect2', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    return
  controller: ($scope, $element, $timeout) ->
    $timeout(->
      $element.select2()
    , 500)
