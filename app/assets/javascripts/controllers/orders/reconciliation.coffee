app = window.app

app.controller "reconciliation", (
  $scope,
  Order,
  Customer,
  Reconciliation
) ->

  $scope.orders = []
  $scope.total = 0.0
  $scope.count = 0

  $scope.selectByDate = (from, to) ->
    Reconciliation.query({from: from, to: to}).then ((results) ->
      $scope.orders = results.orders
      $scope.from = undefined
      $scope.to = undefined
      $scope.total = results.total
      $scope.count = results.count
      return
    ), (error) ->
      return

  $scope.selectByDate('today')
