app = window.app

app.controller "orderBluePrint", (
  $scope,
  $timeout,
  Order,
  Customer,
  Category,
  ConsumptionRecord,
  Service,
  Address,
  Friend,
  Photo,
  Desc,
  PhotoSymptom,
  $rootScope,
  $state,
  $stateParams,
  $location,
  $anchorScroll
) ->

  $scope.getOrderPhotos = (orderNumber) ->
    Photo.query({orderNumber: orderNumber, used: true, stype: false}).then ((results) ->
      $scope.photos = results.allPhotos
      $scope.itemParts = results.itemParts
      _.each($scope.photos, (photo)->
        if results.itemParts && results.itemParts[0]
          categoryIds = [results.itemParts[0].parentId]

        unless photo.symptoms.length
          photo.symptoms[0] = {
            options: results.itemParts
            symptoms: [$scope.order.showItemType]
            categoryIds: categoryIds || []
          }
      )
    ), (error) ->
      console.log error

  $scope.getOrderPhotos($stateParams.orderNumber) unless $scope.photos.length

  $scope.$watch('photos', (newValue, oldValue) ->
    $scope.updatePhotos(newValue)
  , true)
