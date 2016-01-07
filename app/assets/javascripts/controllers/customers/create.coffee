app = window.app

app.controller "CreateCustomer", ($scope, $http, Order, Customer, ConsumptionRecord, Service, $rootScope) ->

  # query customer by name 
  $scope.queryStr = ''
  $scope.inputValueChange = (queryStr)->
    $scope.showSearchOptions = true

    Customer.query({q: queryStr}).then ((results) ->
      $scope.customers = {}
      $scope.customers = results
      if results.length == 0
        $scope.showAddNewCustomer = true
      else
        $scope.showAddNewCustomer = false

      return
    ), (error) ->
      return

  validateCustomer = () ->
    str = []

    unless $scope.queryStr
      str.push("姓名")
    unless $scope.currentCustomer.phone
      str.push("电话")
    unless $scope.currentCustomer.email
      str.push("邮箱")


    unless _.isEmpty(str)
      $scope.alertWith("客户#{str.join('，')}不能为空！", 'danger')
      return false
    return true

  # submit customer info
  $scope.submitCustomerInfo = () ->
    if validateCustomer()
      if $scope.showAddNewCustomer
        new Customer($scope.currentCustomer).create().then ((results) ->
          $scope.currentCustomer.id = results.id
          $scope.goToNextStep()
        ), (error) ->
          console.log error
