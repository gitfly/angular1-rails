app = window.app

app.controller 'ReworkOrders', (
  $scope,
  Order,
  $state,
  dialogs
) ->

  $scope.reworks = {}
  $scope.workerReworks = []
  $scope.soluReworks = []

  Order.$get('/api/v1/orders/reworks').then ((results) ->
    $scope.reworks = results
    $scope.workerReworks = results.workerReworks
    $scope.soluReworks = results.soluReworks
  ), (error) ->
    console.log error
