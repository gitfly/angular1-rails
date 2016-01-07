app = window.app
app.controller "orderSendEffectResult", (
  $scope, $stateParams, SoluTemplate, Customer
) ->
  $scope.handleStatus = "效果方案已发送顾问"
  $scope.showStatusButtonChangeTo(true)
  $scope.setFinalStatus('effect_result_sent')
  $scope.setOriginalStatus('effect_result_created')
