app = window.app

app.controller "selectCustomer", (
  $scope, $modalInstance, data, Customer, focus, $state, $timeout
) ->
  focus("select-customer")

  $scope.createForm = false
  $scope.customer = {
    gender: false
    sensitivity: 0
  }

  $scope.showCustomerList = false
  $scope.customers = []

  $scope.cancel = ->
    $modalInstance.dismiss('Canceled')
    # $modalInstance.close(result)
  
  $scope.searchCustomerStringChange = (searchStr) ->
    $scope.createForm = false
    $scope.showCustomerList = true
    Customer.$get('/api/v1/customers/info', {q: searchStr}).then ((results) ->
      $scope.customers = results
    ), (error) ->
      console.log error

  $scope.searchStrChange = (event) ->
    if event.charCode == 13
      unless $scope.customers[0]
        $scope.createNewCustomer()
      else
        $scope.customerSelected($scope.customers[0])
      return false

  $scope.customerSelected = (customer) ->
    $scope.showCustomerList = false
    $state.go('payOrder', {customerId: customer.id, orderType: 'pre'})
    $modalInstance.close()

  $scope.createNewCustomer = (val=true) ->
    unless val
      focus("select-customer")
    $scope.createForm = val
    $scope.showCustomerList = !val

  $scope.customerFormCanSubmit = true
  $scope.submitCustomer = (customer) ->
    $scope.customerFormCanSubmit = false
    $timeout(->
      $scope.customerFormCanSubmit = true
    , 2000)

    new Customer(customer).create().then ((result) ->
      $scope.createForm = false
      $scope.showCustomerList = false
      $modalInstance.close()
      $state.go('payOrder', {customerId: result.id, orderForm: true})
    ), (error) ->
        console.log error

  $scope.validateCustomer = (form, attr, value) ->
    Customer.$get(
      '/api/v1/customers/exists', {attr: attr, value: value}
    ).then ((result) ->
      form["customer#{attr.capitalize()}"].exists = (result == 'true')
    ), (error) ->
      console.log error
