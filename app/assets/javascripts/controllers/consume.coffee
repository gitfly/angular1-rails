app = window.app

app.controller "consumeCtrl", (
  $scope,
  $timeout,
  Order,
  Customer,
  ConsumptionRecord,
  Service,
  $rootScope,
  $state,
  $location,
  $anchorScroll
) ->
  $scope.consumeForm = false
  $scope.currentCustomer = {}

  $scope.showconsumeForm = (status) ->
    $scope.consumeForm = status

  $scope.consume = {}
  $scope.consumeAccount = (consume)->
    console.log consume
    console.log $scope.currentCustomer
    new ConsumptionRecord(
      $.extend(consume, {customerId: $scope.currentCustomer.id})
    ).create().then ((results) ->
      $scope.$emit('orderConsumeSuccessfully', results.customer)
      $scope.consumeForm = false
      $scope.currentCustomer = results.customer
      $scope.alertWith("付款成功！")
    ), (error) ->
      console.log error

  $scope.$on 'showConsumeForm', (event, data) ->
    $scope.consumeForm = data.status
    $scope.currentCustomer = data.customer
    event.stopPropagation
