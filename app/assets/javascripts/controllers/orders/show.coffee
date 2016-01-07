app = window.app

app.controller "showOrder", (
  Order,
  Photo
  $scope,
  $state,
  OrderLog,
  $timeout,
  $stateParams
) ->

  getCurrentOrder = (orderId) ->
    if $scope.currentOrder.id != parseInt(orderId)
      Order.get(orderId, {log: true}).then (results) ->
        $scope.setCurrentOrder(results)
        $scope.scrollToActiveItem()
        $scope.$broadcast('currentOrderChanged', {})
        return

  statusChange = (status) ->
    Order.$put(
      "api/v1/orders/#{$scope.currentOrder.id}/#{status}"
    ).then ((result) ->
      angular.extend($scope.currentOrder, result)
      $scope.alertWith("订单状态已更新为#{$scope.currentOrder.showStatusZh}！")
    ), (error) ->
      console.log error

  $scope.backToLastStatus = ->
    statusChange('back_to_last_status')

  $scope.gotoNextStatus = ->
    statusChange('goto_next_status')

  $scope.setOriginalStatus = (status) ->
    $scope.originalStatus = status

  $scope.setFinalStatus = (status) ->
    $scope.finalStatus = status

  $scope.showStatusButtonChangeTo = (val) ->
    $scope.showStatusButton = val

  $scope.updatePhotos = (photos) ->
    $scope.photos = photos

  $scope.updateCurrentOrder = (order) ->
    Order.get(order.id).then (results) ->
      $scope.setCurrentOrder(results)
      $scope.changeUrlParams($state.current, {orderId: results.id})
      return

  $scope.getOrderPhotos = (orderId, withChild=false) ->
    Photo.$get(
      "/api/v1/orders/#{orderId}/photos", {withChild: withChild}
    ).then ((results) ->
      $scope.photos = results.before
      $scope.afterPhotos = results.after || []
    ), (error) ->
      console.log error

  $scope.saveOrder = (order) ->
    $scope.orderCanSubmit = false
    $timeout ->
      $scope.orderCanSubmit = true
    , 2000
    order.template = 'update_with_log'
    new Order(order).update().then ((result) ->
      $scope.unshiftLog(new OrderLog(result.log))
      $scope.alertWith("订单#{order.number}更新成功！")
    ), (error) ->
      console.log error

  

  $scope.$on('inputFocused', (event, args) ->
    $scope.disableShortcut = true
  )

  $scope.$on('inputBlured', (event, args) ->
    $scope.disableShortcut = false
  )

  $scope.$on('escKeyDown', (event, args) ->
    unless $scope.disableShortcut
      $scope.hideOrder()
  )

  $scope.$on('rightKeyDown', (event, args) ->
    unless $scope.disableShortcut
      $scope.showNextOrder()
  )

  $scope.$on('leftKeyDown', (event, args) ->
    unless $scope.disableShortcut
      $scope.showPreOrder()
  )
  


  $scope.photos = []
  $scope.afterPhotos = []
  $scope.showOrderDetails()
  $scope.disableShortcut = false
  $scope.showStatusButton = false
  $scope.currentState = $state.current
  getCurrentOrder($stateParams.orderId)
