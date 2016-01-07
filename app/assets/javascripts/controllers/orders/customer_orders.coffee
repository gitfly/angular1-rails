app = window.app
app.controller "customerOrders", (
  $scope, $stateParams, SoluTemplate, Customer, Order
) ->

  getCustomerOrders = (status, withCounts=true)->
    if $scope.customer && $scope.customer.id
      Customer.$get(
        "api/v1/customers/#{$scope.customer.id}/orders", {
          status: status, withCounts: withCounts
        }
      ).then ((results) ->
        $scope.orderCounts = results.counts
        $scope.cOrders[status] = results.orders
      ), (error) ->
        console.log error

  $scope.showOrdersChange = (status) ->
    $scope.showOrders[status] = !$scope.showOrders[status]
    getCustomerOrders(status)

  $scope.showOrders = {}
  $scope.handleStatus ||= $scope.params.status
  $scope.showOrders[$scope.handleStatus] = true

  $scope.cOrders = {}
  $scope.orderCounts = {}
  getCustomerOrders($scope.handleStatus)
