app = window.app
app.controller "orderDiagnose", ($scope) ->
  $scope.cOrders = {}
  $scope.editBasicInfo = false
  $scope.setFinalStatus('diagnosed')
  $scope.showStatusButtonChangeTo(true)
  $scope.handleStatus = '顾问完成分拣(待诊断)'
  $scope.setOriginalStatus('adviser_sorted_out')

  $scope.editBasicInfoChange = (value) ->
    $scope.editBasicInfo = value

  $scope.saveOrderInfo = (order) ->
    $scope.saveOrder(order)
    $scope.editBasicInfo = false

  $scope.$watch('item', (newValue, oldValue) ->
    $scope.currentOrder.item = newValue
  , true)

  $scope.$watch('currentOrder.startWorkDate', (newValue, oldValue) ->
    $scope.currentOrder.finishDate =
      moment(newValue).add(15, 'days').format('YYYY-MM-DD')
  , true)
