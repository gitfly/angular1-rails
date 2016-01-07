app = window.app

app.controller "orderDelivery", (
  $scope,
  Order,
  Photo,
  OrderStatus,
  $rootScope,
  $state,
  $stateParams,
  dialogs
) ->
  $scope.verified = $scope.order.showStatus == 'delivery'
