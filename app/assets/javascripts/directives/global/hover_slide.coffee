app = angular.module("hoverSlide", [])

app.directive 'hoverSlide', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    target = elem.find(elem.data('target'))

    elem.find('input').focus ->
      unless target.hasClass('shown')
        target.addClass('shown')

    addShown = ->
      if target.hasClass('shown')
        target.removeClass('shown')
      else
        target.addClass('shown')

    elem.hover ->
      addShown()
    , ->
      addShown()
