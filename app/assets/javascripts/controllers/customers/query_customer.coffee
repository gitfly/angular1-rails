app = window.app

app.factory "Customer", (railsResourceFactory) ->
  railsResourceFactory
    url: "/api/v1/customers"
    name: "customer"

app.controller "QueryCustomer", ($scope, $http, Customer) ->
  # $scope.queryStr = ''

  # $scope.showSearchOptions = false
  # $scope.showAddNewCustomer = false
  # $scope.showChargeForm = false
  # $scope.customers = {}
  # $scope.currentCustomer = {}

  # $scope.inputValueChange = (queryStr)->
  #   $scope.showSearchOptions = true

  #   Customer.query({q: queryStr}).then ((results) ->
  #     $scope.customers = {}
  #     $scope.customers = results
  #     if results.length == 0
  #       $scope.showAddNewCustomer = true
  #     else
  #       $scope.showAddNewCustomer = false

  #     return
  #   ), (error) ->
  #     return

  # $scope.clickSearchOption = (index) ->
  #   $scope.showSearchOptions = false
  #   customer = $scope.customers[index]
  #   $scope.currentCustomer = customer
  #   $scope.showChargeForm = false
  #   $scope.queryStr = customer.name

  # $scope.addNewCustomerClicked = () ->
  #   $scope.showChargeForm = true
  #   $scope.currentCustomer = {}
  #   $scope.showSearchOptions = false

  # $scope.isMember = true
  # $scope.memberStatusChange = (value) ->
  #   $scope.isMember = value

  # $scope.consumptionAmountChange = (consumptionAmount)->
  #   $scope.currentCustomer.balance = consumptionAmount
