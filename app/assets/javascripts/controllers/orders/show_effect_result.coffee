app = window.app
app.controller "showEffectResult", (
  $scope, $stateParams, SoluTemplate, Customer
) ->

  $scope.itemTitle = ->
    if $scope.item && $scope.item.id
      "#{$scope.item.color}-#{_.last($scope.item.brand.split(' '))}"

  getAfterTemplate = ->
    SoluTemplate.$get(
      "api/v1/orders/#{$stateParams.orderId}/template", {type: 'after'}
    ).then ((results) ->
      $scope.template = results
    ), (error) ->
      console.log error

  $scope.template = {}
  getAfterTemplate()
  $scope.getOrderPhotos($stateParams.orderId, true)
