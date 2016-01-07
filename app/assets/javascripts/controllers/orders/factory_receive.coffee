app = window.app

app.controller "orderFactoryReceive", (
  $scope,
  Order,
  Photo,
  OrderStatus,
  $rootScope,
  $state,
  $stateParams,
  dialogs
) ->
  $scope.verified = $scope.order.showStatus == 'factory_receive'
