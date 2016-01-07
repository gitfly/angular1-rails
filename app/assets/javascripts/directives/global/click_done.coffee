app = angular.module("clickDone", [])

app.directive 'clickDone', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    elem.bind 'click', () ->
      if $(this).hasClass('todo-done')
        $(this).removeClass('todo-done')
      else
        $(this).addClass('todo-done')
