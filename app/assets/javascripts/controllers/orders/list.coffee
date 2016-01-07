app = window.app

app.controller "OrderList", (
  $scope,
  $http,
  $sce,
  Order,
  OrderStatus,
  $state,
  Printer,
  dialogs,
  $stateParams
  Rails
) ->
  
