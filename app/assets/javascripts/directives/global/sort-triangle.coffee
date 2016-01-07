app = angular.module("sortTriangle", [])

app.directive 'sortTriangle', () ->
  restrict: "AE"
  replace: true
  template: (elem, attrs) ->
    return "<th ng-click=orderByAttribute('#{attrs.orderBy}') class='pointer sorted-column'>#{attrs.text}<span class='triangle' ng-class=\"{'fui-triangle-up': !orderDescs['#{attrs.orderBy}']&&orderDescs['#{attrs.orderBy}']!=undefined, 'fui-triangle-down': orderDescs['#{attrs.orderBy}']||orderDescs['#{attrs.orderBy}']==undefined}\"></span> </th>"
