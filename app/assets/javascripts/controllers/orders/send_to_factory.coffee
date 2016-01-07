app = window.app

app.controller "orderSendToFactory", (
  $scope,
  Order,
  Photo,
  OrderStatus,
  $rootScope,
  $state,
  $stateParams,
  dialogs
) ->
  $scope.verified = $scope.order.showStatus == 'send_to_factory'
