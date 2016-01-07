app = angular.module("timePicker", [])

app.directive 'timePicker', () ->
  restrict: "A"
  link: ($scope, elem, attrs) ->
    $(elem).timepicker(
      'className': 'timepicker-primary',
      'timeFormat': 'h:i A',
      'minTime': '7:00AM',
      'maxTime': '11:30PM',
      'step': 60
    )
    return
