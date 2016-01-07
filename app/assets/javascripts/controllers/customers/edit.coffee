app = window.app

app.controller "editCustomer", (
  $scope, $modalInstance, data, Customer, $state, $timeout
) ->
  $scope.customer = data.customer

  $scope.cancel = ->
    $modalInstance.dismiss('Canceled')
    # $modalInstance.close(result)
    
  $scope.customerFormCanSubmit = true
  $scope.submitCustomer = (customer) ->
    $scope.customerFormCanSubmit = false
    $timeout(->
      $scope.customerFormCanSubmit = true
    , 2000)

    new Customer(customer).update().then ((result) ->
      $modalInstance.close($scope.customer)
    ), (error) ->
        console.log error

  $scope.validateCustomer = (form, attr, value) ->
    Customer.$get(
      '/api/v1/customers/exists', {attr: attr, value: value}
    ).then ((result) ->
      form["customer#{attr.capitalize()}"].exists = (result == 'true')
    ), (error) ->
      console.log error
