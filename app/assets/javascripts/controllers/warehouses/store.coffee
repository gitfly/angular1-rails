app = window.app

app.controller "storeCtrl", (
  $scope,
  Store
) ->
  $scope.store = {}
  Store.query({}).then ((results) ->
    $scope.store.advanceOrderCount = results.advanceOrderCount
    $scope.store.sendToFactoryCount = results.sendToFactoryCount
    $scope.store.factoryReceiveCount = results.factoryReceiveCount
    $scope.store.outOfStorageCount = results.outOfStorageCount
    $scope.store.storeReceiveCount = results.storeReceiveCount
    $scope.store.completeCount = results.completeCount
    $scope.abnormalOrders = results.abnormalOrders
  ), (error) ->
    return
  



  









