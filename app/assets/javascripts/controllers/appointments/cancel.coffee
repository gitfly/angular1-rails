app = window.app

app.controller "cancelAppointment", ($scope, $modalInstance, data, Appointment) ->
  $scope.appointment = data.appointment

  $scope.cancel = ->
    $modalInstance.dismiss('Canceled')

  $scope.submit = (appointment) ->
    Appointment.$put(
      "/api/v1/appointments/#{appointment.id}/cancel", appointment
    ).then ((result) ->
      $modalInstance.close()
    ), (error) ->
      console.log error
