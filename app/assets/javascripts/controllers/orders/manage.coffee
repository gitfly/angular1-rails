app = window.app

app.controller "ManageOrder", (
  $scope,
  Order,
  Photo,
  OrderStatus,
  $rootScope,
  $state,
  $stateParams,
  $upload,
  $sce,
  dialogs
) ->
  $scope.order = {}
  $scope.photos = []
  $scope.itemParts = []
  $scope.customer = {}
  $scope.item = {}
  $scope.barcode = ''

  $scope.getInitOrder = (callback) ->
    Order.get($stateParams.orderNumber).then ((result) ->
      $scope.order = result
      $scope.itemParts = result.itemParts
      $scope.customer = result.customer
      $scope.item = result.item
      $scope.address = result.address
      $scope.friend = result.friend
      $scope.barcode = $sce.trustAsHtml(result.barcodeHtml)
      first_name = $scope.customer.name
      if first_name && first_name.charAt(0).match(/^[\u4e00-\u9fa5]+$/)
         first_name = first_name.charAt(0)
      
      if $scope.customer.gender
        $scope.order.callName = "#{first_name}同学"
      else
        $scope.order.callName = "#{first_name}MM"

      $scope.order.itemTitle = "#{$scope.item.color}#{$scope.item.brand}#{$scope.order.showItemType}"

      if $state.current.name == 'manageOrder'
        $state.go(".#{$scope.order.nextStatus}")

      if callback
        callback($scope.order.id)
    ), (error) ->
      console.log error
  $scope.getInitOrder()

  $scope.confirmStatusFor = (status) ->
    new OrderStatus(
      orderId: $scope.order.id,
      status: status
    ).create().then ((result) ->
      $.extend($scope.order, result.order)
      $scope.alertWith("状态更新成功。")
    ), (error) ->
      console.log error


  $scope.cancelCurrentStatus = () ->
    new OrderStatus(
      orderId: $scope.order.id,
      status: $scope.order.lastStatus
    ).create().then ((result) ->
      $.extend($scope.order, result.order)
      $scope.alertWith("状态更新成功。")
    ), (error) ->
      console.log error

  $scope.updatePhotos = (photos) ->
    $scope.photos = photos

  $scope.pageHtml = (val) ->
    if val
      val = val.replace(/\n/g, '<br/>')
    # console.log val
    $sce.trustAsHtml(val)


