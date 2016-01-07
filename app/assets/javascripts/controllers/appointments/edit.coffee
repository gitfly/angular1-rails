app = window.app

app.controller "editAppointment", ($scope, $modalInstance, data, Appointment) ->
  $scope.companyNames = [
    "申通快递", "顺丰速运", "圆通快递", "韵达快递",
    "中通快递", "EMS邮政特快", "如风达快递", "快捷快递",
    "天天快递", "德邦物流", "宅急送", "百世汇通", "优速快递", "速尔快递"
  ]
  $scope.appointment = data.appointment
  $scope.appointment.deliveryDate = data.appointment.date
  $scope.appointment.deliveryHourEnd = data.appointment.dateDetailEnd
  $scope.appointment.deliveryHourStart = data.appointment.dateDetailStart
  $scope.appointment.express ||= {}
  $scope.appointment.express.companyName =
    $scope.companyNames[data.appointment.express.companyType]

  $scope.cancel = ->
    $modalInstance.dismiss('Canceled')

  $scope.submit = (appointment) ->
    appointment.date = appointment.deliveryDate
    appointment.dateDetailEnd = appointment.deliveryHourEnd
    appointment.dateDetailStart = appointment.deliveryHourStart
    appointment.express.companyType =
      _.indexOf($scope.companyNames, appointment.express.companyName)
    new Appointment(appointment).update().then ((result) ->
      debugger
      $modalInstance.close(result)
    ), (error) ->
      console.log error
