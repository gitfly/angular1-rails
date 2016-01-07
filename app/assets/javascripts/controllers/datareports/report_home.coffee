app = window.app

app.controller "reportHomeCtrl", (
  $scope,
  Order,
  Customer,
  ReportHome
) ->
  $scope.results = []
  $scope.from = undefined
  $scope.to = undefined
  
  $scope.selectByDate = (from, to) ->
    ReportHome.query({from: from, to: to}).then ((results) ->
      $scope.results = results[0]
      $scope.from = results[1]
      $scope.to = results[2]
      return
    ), (error) ->
      return

  $scope.selectByDate()
