app = window.app

app.controller "customerDetailCtrl", (
  $scope,
  Order,
  Customer,
  Activity,
  PaymentDetail,
  CustomerDetail
) ->
  $scope.is_member = undefined
  $scope.total_consume_num = undefined
  $scope.total_order_num = undefined
  $scope.recent_order_num = undefined
  $scope.customer_source = undefined
  $scope.from = undefined
  $scope.to = undefined
  $scope.export_from = undefined


  $scope.selectByDate = (from, to) ->
    $scope.export_from = from
    $scope.conditions = {
      from : from 
      to : to
      is_member : $scope.is_member
      total_consume_num : $scope.total_consume_num
      recent_order_num : $scope.recent_order_num
      total_order_num : $scope.total_order_num
      customer_source : $scope.customer_source
    }
    
    CustomerDetail.query($scope.conditions).then ((results) ->
      $scope.customers = results.customers
      $scope.old_customers = results.oldCustomers
      $scope.orderd_customers = results.orderdCustomers
      $scope.new_customers = results.newCustomers
      $scope.from = results.from
      $scope.to = results.to
      return
    ), (error) ->
      return

  $scope.selectByDate('today')    



  









