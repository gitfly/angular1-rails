app = window.app

app.controller "orderEffectPhoto", ($scope, Photo, $upload, $stateParams) ->

  $scope.afterPhoto = []
  $scope.setOriginalStatus('blue_print_tested')
  $scope.setFinalStatus('effect_photo_uploaded')
  $scope.getOrderPhotos($stateParams.orderId, true)

  $scope.showTip = (index, value)->
    if $scope.afterPhotos[index]
      $scope.afterPhotos[index].show = value

  $scope.upload = (afterPhoto, beforePhoto, index) ->
    $upload.upload(
      method: 'POST'
      file: afterPhoto[0]
      url: '/api/v1/photos'
      fileFormDataName: 'photo[photo]'
      fields: {
        photoable_type: 'Order'
        parent_id: beforePhoto.id
        photoable_id: $scope.currentOrder.id
      }
      formDataAppender: (fd, key, val) ->
        if angular.isArray(val)
          angular.forEach val, (v) ->
            fd.append 'photo[' + key + ']', v
            return
        else
          fd.append 'photo[' + key + ']', val
          return
    ).progress((evt) ->
      progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
      return
    ).success (data, status, headers, config) ->
      $scope.afterPhotos[index] = new Photo(data)
      $scope.alertWith("图片上传成功。")

  $scope.$watch('afterPhotos', (newValue, oldValue) ->
    $scope.showStatusButtonChangeTo(
      !_.filter(newValue, (photo) ->
        return angular.isUndefined((photo||{}).id)
      ).length
    )
  , true)
