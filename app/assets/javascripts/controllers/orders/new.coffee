app = window.app

app.controller "newOrder", (
  $scope,
  $timeout,
  Order,
  Customer,
  ConsumptionRecord,
  Service,
  ServiceType,
  Address,
  ItemVersion,
  ItemBrand,
  ItemColor,
  Friend,
  $rootScope,
  $state,
  $stateParams,
  $location,
  $anchorScroll
) ->

  initCustomer = {
    gender: '0',
    source: '0',
    referrer: {}
  }

  $scope.customers = []
  $scope.currentIndex = 0
  $scope.currentCustomer = initCustomer
  $scope.serviceTypes = {}
  $scope.serviceTypeKeys = []

  ServiceType.query({}).then ((results) ->
    $scope.serviceTypeKeys = _.keys(results)
    $scope.serviceTypes = results
  ), (error) ->
    console.log error

  $scope.currentOrder = {
    pickupManner: 0,
    deliveryManner: 0,
    urgent: 'false',
    part: [],
    attachment: []
  }

  $scope.currentItem = {
    style: "女款",
    type: 'Wallet'
  }
  $scope.fetchAddress = {}
  $scope.deliveryAddress = {}

  $scope.newCustomerButton = false
  $scope.newOrderForm = true

  #brand select function 
  $scope.showBrandOptions = false
  $scope.brandInputFocus = (val) ->
    $scope.showBrandOptions = val
  $scope.brandKeyPress = (event) ->
    if event.charCode == 13
      $scope.currentItem.brand = $scope.brands[0].brand
      $scope.showBrandOptions = false
    return false
  $scope.brandValueChange = () ->
    $scope.showBrandOptions = true
    ItemBrand.query({brand: $scope.currentItem.brand}).then ((results) ->
      $scope.brands = results
    ), (error) ->
      console.log error
  $scope.selectBrand = (brand) ->
    $scope.currentItem.brand = brand
    $scope.showBrandOptions = false

  # version select function 
  $scope.showVersionOptions = false
  $scope.versionInputFocus = (val) ->
    $scope.showVersionOptions = val
  $scope.versionKeyPress = (event) ->
    if event.charCode == 13
      $scope.currentItem.version = $scope.versions[0].version
      $scope.showVersionOptions = false
    return false
  $scope.versionValueChange = () ->

    if $scope.currentItem.brand
      $scope.showVersionOptions = true
      ItemVersion.query({
        version: $scope.currentItem.version,
        brand: $scope.currentItem.brand
      }).then ((results) ->
        $scope.versions = results
      ), (error) ->
        console.log error
    else
      $scope.alertWith("请先选择品牌！", 'danger')
  $scope.selectVersion = (version) ->
    $scope.currentItem.version = version
    $scope.showVersionOptions = false

  #brand select function 
  $scope.showColorOptions = false
  $scope.colorInputFocus = (val) ->
    $scope.showColorOptions = val
  $scope.colorKeyPress = (event) ->
    if event.charCode == 13
      $scope.currentItem.color = $scope.colors[0].color
      $scope.showColorOptions = false
    return false
  $scope.colorValueChange = () ->
    $scope.showColorOptions = true
    ItemColor.query({color: $scope.currentItem.color}).then ((results) ->
      $scope.colors = results
    ), (error) ->
      console.log error
  $scope.selectColor = (color) ->
    $scope.currentItem.color = color
    $scope.showColorOptions = false

  getCustomer = (queryHash={}) ->
    Customer.query(queryHash).then ((results) ->
      $scope.customers = results
      $scope.referrer = results.referrer
      $scope.currentCustomer = results[0] || initCustomer
      $scope.currentOrder.discount = $scope.currentCustomer.discount

      if $stateParams.customerId && $stateParams.customerId.length && !queryHash.q
        Customer.get($stateParams.customerId).then ((result) ->
          $scope.currentCustomer = result
          $scope.currentOrder.discount = $scope.currentCustomer.discount
          $scope.customers.unshift(result)
          ), (error) ->
            console.log error

      if results.length == 0
        $scope.newCustomerButton = true
        $scope.currentCustomer.phone = queryHash.q
      else
        $scope.newCustomerButton = false
        
    ), (error) ->
      return

  getCustomer()

  $scope.queryByCustomerName = (customerStr) ->
    getCustomer({q: customerStr})

  $scope.selectCustomer = (index) ->
    $scope.currentCustomer = $scope.customers[index]

  $scope.createOrder = ->

    o = $scope.currentOrder

    fetchTime = "#{o.fetchHourStart1}-#{o.fetchHourEnd1}|#{o.fetchHourStart2}-#{o.fetchHourEnd2}"
    deliveryTime = "#{o.deliveryHourStart1}-#{o.deliveryHourEnd1}|#{o.deliveryHourStart2}-#{o.deliveryHourEnd2}"

    order = {
      customerId: $scope.currentCustomer.id,
      item: $scope.currentItem,
      fetchAddress: $scope.fetchAddress,
      deliveryAddress: $scope.deliveryAddress,
      friend: $scope.friend,
      fetchDateDetail: fetchTime,
      deliveryDateDetail: deliveryTime,
      attachment: (o.attachment||[]).join(),
      part: (o.part||[]).join(),
      serviceIds: (o.serviceIds||[]).join()
    }

    new Order(
      $.extend(o, order)
    ).create().then ((results) ->
      $scope.currentCustomer.orders ||= []
      $scope.currentCustomer.orders.push(results)
      $scope.newOrderForm = false
      $scope.alertWith("订单创建成功！")
      $location.hash('content')
      $anchorScroll()
      $state.go('payOrder', {customerId: $scope.currentCustomer.id})
    ), (error) ->
      console.log error

  $scope.createAnotherOrder = ->
    $scope.newOrderForm = true
    $scope.currentOrder.attachment = []
    $scope.currentOrder.part = []

  $scope.goBack = ->
    $state.go('orders')

  $scope.editCustomer = () ->
    $scope.newCustomerButton = true

  $scope.updateCustomerInfo = () ->
    new Customer($scope.currentCustomer).update().then ((results) ->
      $scope.currentCustomer = results
      $scope.newCustomerButton = false
      $scope.alertWith("用户信息更新成功！")
    ), (error) ->
      console.log error
      return

  $scope.createNewCustomer = ()->
    new Customer($scope.currentCustomer).create().then ((results) ->
      $scope.customers.push(results)
      $scope.currentCustomer = results
      $scope.currentOrder.discount = results.discount
      $scope.newCustomerButton = false
      $scope.alertWith("用户创建成功！")
    ), (error) ->
      console.log error
      return

  $scope.$on 'rechargeCustomerSuccessfully', (event, customer) ->
    $scope.currentCustomer = customer
    event.stopPropagation

  $scope.addresses = []

  $scope.fetchMannerChange = (val) ->
    if val != '0'
      $scope.showAddress = true
      # unless $scope.addresses.length
      Address.query({customerId: $scope.currentCustomer.id}).then ((results) ->
        $scope.addresses = results.addresses
      ), (error) ->
        return

  $scope.deliveryMannerChange = (val) ->
    if val != '0'
      $scope.showAddress = true
      Address.query({customerId: $scope.currentCustomer.id}).then ((results) ->
        $scope.addresses = results.addresses
      ), (error) ->
        return

  $scope.showDelivery = false
  $scope.showDeliveryModal = (val=true) ->
    $scope.showDelivery = val

  $scope.friend = {}

  $scope.selectAddress = (address) ->
    $scope.fetchAddress = address

  $scope.selectDeliveryAddress = (address) ->
    $scope.deliveryAddress = address

  $scope.startWorkDateChange = (order) ->
    order.finishDate =
      moment(order.startWorkDate).add(15, 'days').format('YYYY-MM-DD')

  $scope.serviceChange = (ids) ->
    services = _.invert($scope.serviceTypes)
    price = 0.0
    _.each(ids, (id) ->
      prices = services[id].match(/\d+/)
      if prices
        price += parseFloat(prices[0])
    )
    $scope.currentOrder.price = price
