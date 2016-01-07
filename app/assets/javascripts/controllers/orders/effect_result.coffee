app = window.app
app.controller "orderEffectResult", (
  $scope, $stateParams, SoluTemplate, OrderStatus
) ->
  $scope.itemTitle = ->
    if $scope.item.id
      "#{$scope.item.color}-#{_.last($scope.item.brand.split(' '))}"

  $scope.afterPhotosCompleted = ->
    return !_.filter($scope.afterPhotos, (photo) ->
      !photo
    ).length

  getCounselor = ->
    OrderStatus.$get(
      "/api/v1/order_statuses/#{$stateParams.orderId}/handler",
      { status: 'diagnosed' }
    ).then ((results) ->
      $scope.counselor = results
    ), (error) ->
      console.log error

  getAfterTemplate = ->
    SoluTemplate.$get(
      "api/v1/orders/#{$stateParams.orderId}/template", {type: 'after'}
    ).then ((results) ->
      $scope.template = results
    ), (error) ->
      console.log error

  $scope.template = {}
  $scope.counselor = {}

  getCounselor()
  getAfterTemplate()
  $scope.showStatusButtonChangeTo(true)
  $scope.setFinalStatus('effect_result_created')
  $scope.setOriginalStatus('effect_photo_uploaded')
  $scope.getOrderPhotos($stateParams.orderId, true)
