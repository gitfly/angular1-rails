app = window.app

app.controller "orderPhotosController", (
  $scope,
  Order,
  Photo,
  OrderStatus,
  $rootScope,
  $state,
  $stateParams,
  $upload,
  dialogs
) ->

  # ------------------------------------------------------------------------------------------------------------------------------------------
  #                                LOCAL FUNCTIONS HERE
  # ------------------------------------------------------------------------------------------------------------------------------------------

  upload = (file) ->
    $upload.upload(
      url: "/api/v1/photos/#{file.id}"
      fields: {
        id: file.id
      }
      file: file
      method: 'PUT'
      fileFormDataName: 'photo[photo]'
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
      $scope.alertWith("图片上传完成，成功上传图片 #{config.file.name}。")
      _.each($scope.photos, (photo, index) ->
        if photo.id == data.id
          photo.thumbUrl = data.thumb_url
          photo.originalUrl = data.original_url
          photo.showSize = data.show_size
          photo.used = data.used
      )
      return


  
  # ------------------------------------------------------------------------------------------------------------------------------------------
  #                                SCOPE FUNCTIONS HERE
  # ------------------------------------------------------------------------------------------------------------------------------------------

  $scope.removePhoto = (photo, index) ->
    new Photo(photo).remove().then (result) ->
      $scope.photos.splice(index, 1)
    , (error) ->
      console.log error

  $scope.uploads = (files) ->
    if files and files.length
      i = 0
      while i < files.length
        file = files[i]
        upload(file)
        i++
    return

  $scope.generatImageUrl = (files) ->
    $scope.initText = "继续添加照片"
    _.each(files, (file) ->
      f = new Photo({})
      f.thumbUrl = window.URL.createObjectURL(file)
      f.name = file.name
      f.originalUrl = f.thumbUrl
      f.showSize = "#{Math.round(file.size/1024)} KB"
      f.used = true
      $scope.photos.push(f)
      length = $scope.photos.length

      new Photo({
        photoable_id: $scope.currentOrder.id,
        photoable_type: 'Order'
      }).create().then (result) ->
        file.id = result.id
        $scope.photos[length-1].id = result.id
        upload(file)
      , (error) ->
        console.log error
    )

  $scope.changeUseStatus = (photo) ->
    photo.used = !photo.used
    new Photo(photo).update().then ((result) ->
    ), (error) ->
      console.log error

  $scope.sortableOptions = {
    update: (e, ui) ->
    stop: (e, ui) ->
      _.each($scope.photos, (photo, index) ->
        unless index == photo.sequence
          new Photo({sequence: index, id: photo.id}).update().then (result) ->
            $scope.photos[index] = result
          , (error) ->
            console.log error
      )
  }


  
  # ------------------------------------------------------------------------------------------------------------------------------------------
  #                                HANDLE CONTROLLER EVENTS HERE
  # ------------------------------------------------------------------------------------------------------------------------------------------

  $scope.$watch('photos', (newValue, oldValue) ->
    $scope.updatePhotos(newValue)
    if newValue && newValue.length
      $scope.showStatusButtonChangeTo(true)
    else
      $scope.showStatusButtonChangeTo(false)
  , true)



  # ------------------------------------------------------------------------------------------------------------------------------------------
  #                                INITIALIZATION CODES HERE
  # ------------------------------------------------------------------------------------------------------------------------------------------

  $scope.files = []
  $scope.fileArray = []
  $scope.initText = "请选择上传新的照片"
  $scope.setOriginalStatus('diagnosed')
  $scope.setFinalStatus('photo_uploaded')
  $scope.getOrderPhotos($stateParams.orderId) unless $scope.photos.length
