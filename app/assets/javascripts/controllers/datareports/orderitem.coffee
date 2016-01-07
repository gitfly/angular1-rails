app = window.app

app.controller "orderitemCtrl", (
  $scope,
  Order,
  Customer,
  Activity,
  OrderItem
) ->
  $scope.orders = []
  $scope.is_member = undefined
  $scope.activity_id = undefined
  $scope.item_type = undefined
  $scope.from = undefined
  $scope.to = undefined
  $scope.activities = []
  # $scope.conditions = {
  #   is_member : undefined
  #   activity_name : undefined
  #   item_type : undefined
  #   from : undefined
  #   to : undefined
  # }
  Activity.query({}).then ((results) ->
    $scope.activities = results
  ), (error) ->
    return
  $scope.selectByDate = (from, to) ->
    conditions = {
      from : from 
      to : to
      is_member : $scope.is_member
      item_type : $scope.item_type
      activity_id : $scope.activity_id
    }
    OrderItem.query(conditions).then ((results) ->
      $scope.orders = results.orders
      $scope.total_amounts = results.totalAmounts
      # $scope.pm_amounts_hash = results.pmAmountsHash[1]
      $scope.from = results.from
      $scope.to = results.to
      $scope.pre_count = results.preCount
      $scope.formal_count = results.formalCount
      $scope.ordersCount = results.ordersCount

      return
    ), (error) ->
      return
      
  $scope.selectByDate('today')    

  $scope.selectActivity = (val) ->
     $scope.activity_name = val   



  









