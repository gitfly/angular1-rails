app = angular.module("switch", [])

app.directive "switch", ->
  restrict: "A"
  replace: false
  scope: false
  link: (scope, elem, attr) ->
    elem.bootstrapSwitch()
    elem.parents('.bootstrap-switch-wrapper:first').click ->
      model = elem.attr('ng-model')

      if $(this).hasClass('bootstrap-switch-on')
        scope.$apply ->
          scope[model] = true
      else
        scope.$apply ->
          scope[model] = false
    return
