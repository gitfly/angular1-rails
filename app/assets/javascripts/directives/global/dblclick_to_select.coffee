app = angular.module("dblclickToSelect", [])

app.directive 'dblclickToSelect', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    elem.bind 'dblclick', () ->
      $(attrs.target||elem).selectText()

    $(document).keypress "a", (e) ->
      if(e.ctrlKey || e.metaKey)
        $(attrs.target||elem).selectText()
