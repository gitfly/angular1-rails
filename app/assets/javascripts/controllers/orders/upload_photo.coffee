app = window.app

app.controller "orderUploadPhoto", (
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

  $scope.files = []
  $scope.fileArray = []

  $scope.uploaded = $scope.order.status == 4

  $scope.resetText = ->
    $scope.initText = "请选择上传新的照片"

  $scope.resetText()

  $scope.uploadConfirm = () ->
    new OrderStatus(
      orderId: $scope.order.id,
      status: 'upload_photo'
    ).create().then ((result) ->
      $scope.uploaded = true
      $scope.alertWith("照片上传确认完毕。")
    ), (error) ->
      console.log error

  $scope.removePhoto = (photo, index) ->
    new Photo(photo).remove().then (result) ->
      $scope.photos.splice(index, 1)
    , (error) ->
      console.log error

  $scope.getOrderPhotos = (orderNumber) ->
    Photo.query({orderNumber: orderNumber}).then ((results) ->
      unless $scope.photos && $scope.photos.length
        $scope.photos = results.allPhotos
      # $scope.itemParts = results.itemParts
    ), (error) ->
      console.log error

  $scope.getOrderPhotos($stateParams.orderNumber) unless $scope.photos.length

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

      # console.log 'progress: ' + progressPercentage + '% ' + evt.config.file.name

      return
    ).success (data, status, headers, config) ->
      # $scope.photos.push(new Photo(data))
      $scope.alertWith("图片上传完成，成功上传图片 #{config.file.name}。")
      _.each($scope.photos, (photo, index) ->
        if photo.id == data.id
          photo.thumbUrl = data.thumb_url
          photo.originalUrl = data.original_url
          photo.showSize = data.show_size
          photo.used = data.used
      )
      return


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
        photoable_id: $scope.order.id,
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

  $scope.$watch('photos', (newValue, oldValue) ->
    $scope.updatePhotos(newValue)
  , true)
