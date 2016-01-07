app = window.app

app.controller "rechargeCtrl", (
  $scope,
  $timeout,
  Order,
  Customer,
  ConsumptionRecord,
  Recharge,
  Service,
  $rootScope,
  $state,
  $location,
  $anchorScroll
) ->

  $scope.rechargeForm = false
  $scope.currentCustomer = {}

  $scope.showRechargeForm = (status) ->
    $scope.rechargeForm = status

  $scope.recharge = {}
  $scope.rechargeAccount = (recharge)->
    new Recharge(
      $.extend(recharge, {customerId: $scope.currentCustomer.id})
    ).create().then ((results) ->
      $scope.$emit('rechargeCustomerSuccessfully', results.customer)
      $scope.rechargeForm = false
      $scope.currentCustomer = results.customer
      $scope.alertWith("充值#{$scope.recharge.amount}元成功，账户余额为：#{$scope.currentCustomer.balance}")
    ), (error) ->
      console.log error

  $scope.$on 'showRechargeForm', (event, data) ->
    $scope.rechargeForm = data.status
    $scope.currentCustomer = data.customer
    event.stopPropagation
