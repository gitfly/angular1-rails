app = angular.module("dblclickActive", [])

app.directive 'dblclickActive', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    elem.bind 'dblclick', () ->
      $(this).parent().find("#{elem[0].localName}.active").removeClass('active')
      $(this).addClass('active')

    # elem.bind 'click', () ->
    #   $(this).parent().find("#{elem[0].localName}.active").removeClass('active')
    #   $(this).addClass('active')
