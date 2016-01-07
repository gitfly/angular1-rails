app = window.app

app.controller "orderOverdue", (
  $scope,
  $timeout,
  $rootScope,
  $state,
  $stateParams,
  $location,
  $anchorScroll,
  Overdue
) ->

  $scope.orderId = $stateParams.orderId
  $scope.overdue = {
    order_id : $scope.orderId
    original_date : $scope.finish_date
  }
  $scope.getOverdues = () ->
    Overdue.query({orderId: $scope.orderId}).then ((results) ->
      $scope.orderId = $stateParams.orderId
      $scope.overdues = results.overdues
      $scope.order = results.order[0]
      if results.overdues && results.overdues.length > 0
        $scope.finish_date = results.overdues[0].expectedDate
      else
        $scope.finish_date = results.order[0].finishDate

      $scope.overdue.original_date = $scope.finish_date

    ), (error) ->
      console.log error

  $scope.getOverdues()

  
  $scope.getOverDays = () ->
    expected_time = new Date($scope.overdue.expected_date)
    finish_date = new Date($scope.finish_date)
    divNum = 1000 * 3600 * 24
    $scope.overdue_days = parseInt((expected_time.getTime()-finish_date.getTime())/parseInt(divNum))

  $scope.createOverdue = (overdue) -> 
    new Overdue(overdue).create().then ((results) ->
      is_saved = results
      if is_saved
        $scope.alertWith("保存成功！")
        $scope.getOverdues()
        $scope.overdue.reason = null
        $scope.overdue.expected_date = undefined
        $scope.overdue_days = undefined
      else
        $scope.alertWith("保存失败！", 'danger')  

    ), (error) ->
         return
  $scope.isOverdue = () ->
    finashDate = new Date($scope.finish_date)
    now = new Date()
    if now > finashDate
      return true
    else
      return false





