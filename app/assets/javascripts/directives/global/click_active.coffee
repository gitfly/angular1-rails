app = angular.module("clickActive", [])

app.directive 'clickActive', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    elem.bind 'click', () ->
      if $(this).hasClass('active')
        # $(this).removeClass('active')
      else
        $(this).parent().find("#{elem[0].localName}.active").removeClass('active')
        $(this).addClass('active')
