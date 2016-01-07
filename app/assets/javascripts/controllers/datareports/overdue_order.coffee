app = window.app

app.controller "overdueOrderCtrl", (
  $scope,
  OverdueOrder
) ->
 
  $scope.selectByDate = (from) ->
    OverdueOrder.query({from: from}).then ((results) ->
      $scope.overdues = results.overdues
      $scope.from = results.from
      $scope.should_finished =  results.shouldFinished
      return
    ), (error) ->
      return
  $scope.selectByDate()


  









