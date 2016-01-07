app = window.app

app.controller "orderStoreReceive", (
  $scope,
  Order,
  Photo,
  OrderStatus,
  $rootScope,
  $state,
  $stateParams,
  dialogs
) ->
  $scope.verified = $scope.order.showStatus == 'store_receive'
