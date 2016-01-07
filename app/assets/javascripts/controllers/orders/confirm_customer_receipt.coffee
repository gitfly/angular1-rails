app = window.app
app.controller "orderconfirmCustomerReceipt", ($scope, $stateParams) ->
  $scope.cOrders = {}
  $scope.setFinalStatus('customer_receipt_confirmed')
  $scope.showStatusButtonChangeTo(true)
  $scope.handleStatus = '等待顾客收货'
  $scope.setOriginalStatus('waiting_for_customer_receipt')

  $scope.saveOrderInfo = (order) ->
    $scope.saveOrder(order)
    $scope.editBasicInfo = false

