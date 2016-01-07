app = window.app

app.controller "orderStatus", (
  $scope,
  Order,
  OrderLog,
) ->
    if $scope.currentOrder
      OrderLog.query({orderId: $scope.currentOrder.id}).then ((results) ->
        $scope.orderLogs = results
      ), (error) ->
        console.log error
        return
