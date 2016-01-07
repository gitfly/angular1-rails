app = window.app
app.controller "orderConfirmEffectResult", ($scope, $stateParams) ->

  $scope.handleStatus = "效果方案已发送顾客"
  $scope.showStatusButtonChangeTo(true)
  $scope.setFinalStatus('effect_result_confirmed')
  $scope.setOriginalStatus('effect_result_sent')
  $scope.getOrderPhotos($stateParams.orderId, true)
