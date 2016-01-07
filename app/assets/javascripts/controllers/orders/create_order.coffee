app.controller "CreateOrder", ($scope, $http, Order, Customer, ConsumptionRecord, Service, $rootScope) ->
  $scope.newOrderStep = 0

  $scope.goToNextStep = () ->
    if $scope.newOrderStep < 3
      if $scope.newOrderStep == 0 && _.isEmpty($scope.currentCustomer)
        $scope.alertWith("请选择客户或者添加新客户！", 'danger')
        return false
      if $scope.newOrderStep == 1 && _.isEmpty($scope.currentItem.type)
        $scope.alertWith("物品种类不能为空！", 'danger')
        return false

      $scope.newOrderStep += 1

  $scope.goToPrevStep = () ->
    if $scope.newOrderStep > 0
      $scope.newOrderStep -= 1


  $scope.queryStr = ''

  $scope.showSearchOptions = false
  $scope.showAddNewCustomer = false
  $scope.showChargeForm = false
  $scope.customers = {}
  $scope.currentCustomer = {}
  # $scope.currentService = {}
  $scope.currentCon = {}


  $scope.clickSearchOption = (index) ->
    $scope.showSearchOptions = false
    customer = $scope.customers[index]
    $scope.currentCustomer = customer
    $scope.showChargeForm = false
    $scope.queryStr = customer.name

  $scope.addNewCustomerClicked = () ->
    $scope.showChargeForm = true
    $scope.currentCustomer = {}
    $scope.showSearchOptions = false

  # $scope.isMember = true
  # $scope.memberStatusChange = (value) ->
  #   $scope.isMember = value

  $scope.consumptionAmountChange = (consumptionAmount)->
    $scope.currentCustomer.balance = consumptionAmount

  $scope.currentOrder = {}
  $scope.createdOrder = {}

  setOrderDate = () ->
    d = new Date
    d.setDate(d.getDate()+15)

    $scope.currentOrder = {
      receiveDate: toDateString(new Date),
      deliveryDate: toDateString(d)
    }

  toDateString = (date) ->
    return "#{date.getFullYear()}-#{date.getMonth()}-#{date.getDate()}"

  setOrderDate()

  $scope.currentItem = {}

  validateServices = () ->
    if _.isEmpty($scope.currentOrder.serviceIds)
      $scope.alertWith("服务类型不能为空！", 'danger')
      return false
    return true


  $scope.createOrder = () ->
    if validateServices()
      $scope.currentOrder.item = $scope.currentItem
      item = {
        type: $scope.currentItem.type,
        brand: $scope.currentItem.brand,
        style: $scope.currentItem.style,
        color: _.first($scope.currentItem.color)
      }

      joinData = (data) ->
        if data instanceof Array
          return data.join(', ')
        else
          return ''

      order = {
        item: item,
        receiveDate: $scope.currentOrder.receiveDate,
        deliveryDate: $scope.currentOrder.deliveryDate,
        badness: joinData($scope.currentOrder.badness),
        flaw: joinData($scope.currentOrder.flaw),
        serviceIds: joinData($scope.currentOrder.serviceIds),
        maintainPart: joinData($scope.currentOrder.maintainPart),
        attachment: joinData($scope.currentOrder.attachment),
        customerId: $scope.currentCustomer.id
      }

      new Order(order).create().then ((results) ->
        $scope.goToNextStep()
        $scope.createdOrder = results
        # $rootScope.$broadcast('NewOrderCreated', results)
        $scope.currentCon.amount = results.consumption
        $scope.orderCreatedSuccessfully = true
      ), (error) ->
        console.log error

  $scope.showRechargeForm = false
  $scope.rechargeClicked = (value) ->
    $scope.showRechargeForm = value

  $scope.initRechargeValue = () ->
    $scope.rechargeAmount = 0.0
    $scope.rechargePaymentMethod= 0
    $scope.rechargeRemark = ''

  $scope.initRechargeValue()

  $scope.rechargeAccount = () ->
    con = {
      amount: $scope.rechargeAmount,
      paymentMethod: $scope.rechargePaymentMethod,
      remark: $scope.rechargeRemark,
      customerId: $scope.currentCustomer.id,
    }
    new ConsumptionRecord(con).create().then ((results) ->
      $scope.showRechargeForm = false
      $scope.initRechargeValue()
      $scope.currentCustomer.balance = results.customerBalance
      $scope.currentCustomer.isMember = results.customerIsMember
    ), (error) ->
      console.log error
    
  $scope.orderConsumption = true
  $scope.createConsumptionRecord = ()->
    con = {
      amount: -$scope.currentCon.amount,
      paymentMethod: $scope.currentCon.paymentMethod,
      remark: $scope.currentCon.remark,
      customerId: $scope.currentCustomer.id
    }
    new ConsumptionRecord(con).create().then ((results) ->
      $scope.currentCustomer.balance = results.customerBalance
      $scope.currentCon = {}
      $scope.orderConsumption = false
    ), (error) ->
      console.log error

  $scope.orderFinish = () ->
    $scope.currentCustomer = {}
    $scope.currentOrder = {}
    $scope.currentItem = {}
    $scope.newOrderStep = 0
    $scope.queryStr = ''
    $scope.orderCreatedSuccessfully = false
    $scope.orderConsumption = true
    $rootScope.$broadcast('HideOrderCreateForm', true)
