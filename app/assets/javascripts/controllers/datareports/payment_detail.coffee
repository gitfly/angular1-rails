app = window.app

app.controller "paymentDetailCtrl", (
  $scope,
  Order,
  Customer,
  Activity,
  PaymentDetail
) ->
  $scope.is_member = undefined
  $scope.activity_id = undefined
  $scope.item_type = undefined
  $scope.from = undefined
  $scope.to = undefined
  $scope.export_from = undefined
  Activity.query({}).then ((results) ->
    $scope.activities = results
  ), (error) ->
    return
  $scope.selectByDate = (from, to) ->
    $scope.export_from = from
    $scope.conditions = {
      from : from 
      to : to
      is_member : $scope.is_member
      item_type : $scope.item_type
      activity_id : $scope.activity_id
    }
    
    PaymentDetail.query($scope.conditions).then ((results) ->
      $scope.orders = results.orders
      $scope.total_amounts = results.totalAmounts
      $scope.pm_amounts = results.pmAmountsHash
      $scope.from = results.from
      $scope.to = results.to
      $scope.ordersCount = results.ordersCount

      return
    ), (error) ->
      return
      
  $scope.selectByDate('today')


  









