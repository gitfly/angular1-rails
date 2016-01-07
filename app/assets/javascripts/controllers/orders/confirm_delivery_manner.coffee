app = window.app
app.controller "orderConfirmDeliveryManner", (
  $scope, $stateParams, Customer, Address, PreviousState, $state
) ->

  $scope.saveOrderInfo = (order) ->
    $scope.saveOrder(order)
    $scope.editDeliveryManner = false

  $scope.showDeliveryManner = ->
    _.keys($scope.deliveryManners)[$scope.currentOrder.deliveryManner]

  $scope.editStatusChange = (val) ->
    $scope.editDeliveryManner = val

  $scope.useAddress = (address) ->
    $scope.currentOrder.deliveryAddress = address

  getAddresses = (customerId) ->
    if customerId
      Address.query({customerId: customerId}).then ((results) ->
        $scope.addresses = results.addresses
      ), (error) ->
        return

  $scope.getUnfinishedOrders = (customerId)->
    Customer.$get("/api/v1/customers/#{customerId}/unfinished_orders").then ((results) ->
      $scope.paidCount = results.paidCount
      $scope.paidOrders = results.paidOrders
      $scope.unpaidCount = results.unpaidCount
      $scope.unpaidOrders = results.unpaidOrders
    ), (error) ->
      console.log error

  $scope.$on('currentOrderChanged', (event, args) ->
    if $scope.customer && $scope.customer.id
      getAddresses($scope.customer.id)
      $scope.getUnfinishedOrders($scope.customer.id)
  )

  $scope.deliveryManners = {
    "顾客来店取": 0,
    "朋友来店代取": 1,
    "包拯上门送": 2,
    "快递": 3
  }

  $scope.paidCount = 0
  $scope.addresses = []
  $scope.paidOrders = []
  $scope.unpaidCount = 0
  $scope.unpaidOrders = []
  $scope.handleStatus = "修复完成已入库"
  $scope.editDeliveryManner = false
  $scope.setOriginalStatus('repaired_into_storage')
  $scope.showStatusButtonChangeTo(true)
  $scope.setFinalStatus('delivery_manner_confirmed')

  if PreviousState.name != $state.current.name
    if $scope.customer && $scope.customer.id
      getAddresses($scope.customer.id)
      $scope.getUnfinishedOrders($scope.customer.id)
