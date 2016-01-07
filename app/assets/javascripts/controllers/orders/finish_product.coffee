app = window.app

app.controller "orderFinishProduct", (
  $scope,
  Order,
  Photo,
  OrderStatus,
  $rootScope,
  $state,
  $stateParams,
  dialogs
) ->
  $scope.verified = $scope.order.showStatus == 'finish_product'
