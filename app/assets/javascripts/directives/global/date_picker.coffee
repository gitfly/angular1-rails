app = angular.module("datePicker", [])

app.directive 'datePicker', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    if elem.is('input')
      elem.datepicker({
        showOtherMonths: true,
        selectOtherMonths: true,
        dateFormat: 'yy-mm-dd',
        yearRange: '-1:+1'
      }).prev('.input-group-btn').on 'click', (e) ->
        e && e.preventDefault()
        elem.focus()

      elem.datepicker('widget').css({
        'margin-left': -elem.prev('.input-group-btn').find('.btn').outerWidth() + 3
      })

      elem.focus ->
        elem.parents('.input-group:first').addClass('active')

      elem.blur ->
        elem.parents('.input-group:first').removeClass('active')

    return
