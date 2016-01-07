window.app.controller "orderInfoController", ($scope, OrderLog) ->
  $scope.showStatusButtonChangeTo(false)

  $scope.loadMoreLogs = ->
    OrderLog.$get(
      "/api/v1/order_logs/#{_.first($scope.logs).id}/load_more",
      { orderId: $scope.currentOrder.id }
    ).then ((results) ->
      $scope.concatLogs(results)
    ), (error) ->
      console.log error
