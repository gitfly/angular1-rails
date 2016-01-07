app = window.app

app.controller "orderDelete", ($scope, $modalInstance, data, Order) ->
  $scope.cancel = ->
    $modalInstance.dismiss('Canceled')

  $scope.delete = ->
    Order.$delete(
      "/api/v1/orders/#{data.order.id}/delete_with_reason"
    ).then ((result) ->
      $modalInstance.close()
    ), (error) ->
      console.log error.data
    return
