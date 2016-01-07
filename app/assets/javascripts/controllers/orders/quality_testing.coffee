app = window.app

app.controller "orderQualityTesting", (
  $scope,
  Order,
  Photo,
  OrderStatus,
  $rootScope,
  $state,
  $stateParams,
  dialogs
) ->







  # $scope.verified = $scope.order.showStatus == 'quality_testing'
  # $scope.getOrderPhotos = (orderNumber) ->
  #   Photo.query({orderNumber: orderNumber}).then ((results) ->
  #     $scope.photos = results.allPhotos
  #     $scope.itemParts = results.itemParts
  #     _.each($scope.photos, (photo)->
  #       unless photo.symptoms.length
  #         photo.symptoms[0] = {
  #           options: results.itemParts
  #           symptoms: [$scope.order.showItemType]
  #           categoryIds: [results.itemParts[0].parentId]
  #         }
  #     )
  #   ), (error) ->
  #     console.log error

  # $scope.getOrderPhotos($stateParams.orderNumber) unless $scope.photos.length

  # $scope.$watch('photos', (newValue, oldValue) ->
  #   $scope.updatePhotos(newValue)
  # , true)
