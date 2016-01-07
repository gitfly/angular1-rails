app = window.app

app.controller "verifyOrder", (
  $scope,
  Order,
  Photo,
  OrderStatus,
  $rootScope,
  $state,
  $stateParams,
  dialogs
) ->
  # 订单状态，订单确认: 7, 
  $scope.verified = $scope.order.status == 7

  # if parseInt($scope.order.status) < 6
  #   $scope.alertWith("请先完成方案", 'danger')
  #   $state.go('manageOrder.bluePrint')

  $scope.verifyOrder = (orderId) ->
    new OrderStatus(
      orderId: orderId,
      status: 'verify_order'
    ).create().then ((result) ->
      $scope.verified = true
      $scope.alertWith("订单确认完毕。")
    ), (error) ->
      console.log error

  $scope.unverifyOrder = (orderId) ->
    new OrderStatus(
      orderId: orderId,
      status: $scope.order.lastStatus
    ).create().then ((result) ->
      $scope.verified = false
      $scope.alertWith("订单确认已取消。")
    ), (error) ->
      console.log error
