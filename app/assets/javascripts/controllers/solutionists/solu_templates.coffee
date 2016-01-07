app = window.app

app.controller 'soluTemplates', (
  $scope,
  Photo,
  dialogs,
  $upload,
  SoluTemplate
) ->

  $scope.templates = []
  $scope.template = {}
  $scope.fileArray = []
  $scope.before = 0
  $scope.headerChanged = false
  $scope.footerChanged = false

  getTemplates = () ->
    SoluTemplate.query({before: $scope.before}).then (results) ->
      $scope.templates = results.templates
      if results.templates.length
        $scope.selectTemplate(results.templates[0], 0)
    , (error) ->
      console.log error.data

  getTemplates()

  $scope.setTemplateType = (val) ->
    $scope.before = val
    getTemplates()

  $scope.selectTemplate = (template, index) ->
    $scope.template = template
    $scope.template.index = index
    unless $scope.template.headerPhotos || $scope.template.footerPhotos
      $scope.template.headerPhotos = []
      $scope.template.footerPhotos = []
      _.each($scope.template.photos, (photo) ->
        if photo.header
          $scope.template.headerPhotos.push(photo)
        else
          $scope.template.footerPhotos.push(photo)
      )

  $scope.upload = (files, header) ->
    if files and files.length
      i = 0
      while i < files.length
        file = files[i]
        $upload.upload(
          url: '/api/v1/photos'
          fields: {
            header: header,
            photoable_id: $scope.template.id,
            photoable_type: 'SoluTemplate'
          }
          file: file
          method: 'POST'
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

          # progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
          # console.log 'progress: ' + progressPercentage + '% ' + evt.config.file.name

          return
        ).success (data, status, headers, config) ->
          photo = new Photo(data)
          $scope.template.photos.push(photo)
          if header
            $scope.template.headerPhotos.push(photo)
          else
            $scope.template.footerPhotos.push(photo)

          $scope.templates[$scope.template.index] = $scope.template

          # $scope.photos.push(new Photo(data))
          $scope.alertWith("图片上传完成，成功上传图片 #{config.file.name}。")
          # $scope.fileArray.splice(0, 1)
          # if _.last(files).name == config.file.name
          #   $scope.fileArray = []
          return
        i++
    return

  $scope.deleteTemplate = (template, index) ->
    dialogs.confirm(
      '', "确定删除该模板吗？", {size: 'md'}
    ).result.then ((btn) ->
      new SoluTemplate({id: template.id}).delete().then ((result) ->
        $scope.templates.splice(index, 1)
        $scope.template = $scope.templates[0]
      ), (error) ->
        console.log error.data
        return
      return
    ), (btn) ->
      return

  $scope.headerChange = () ->
    $scope.headerChanged = true

  $scope.footerChange = () ->
    $scope.footerChanged = true
  
  $scope.updateTemplate = (template) ->
    if $scope.headerChanged || $scope.footerChanged
      t = {
        id: template.id,
        header: template.header,
        footer: template.footer
      }
      new SoluTemplate(t).update().then ((result) ->
        $scope.templates[template.index] = template
        $scope.alertWith("模板更新成功！")
        $scope.headerChanged = false
        $scope.footerChanged = false
      ), (error) ->
        console.log error.data
        return

  $scope.createTemplate = (template) ->
    new SoluTemplate({before: $scope.before}).create().then ((result) ->
      $scope.template = result
      $scope.templates.unshift(result)
    ), (error) ->
      console.log error.data
      return

  $scope.deletePhoto = (photo, index) ->
    dialogs.confirm(
      '', "确定删除该图片吗？", {size: 'md'}
    ).result.then ((btn) ->
      new Photo({id: photo.id}).delete().then ((result) ->
        if photo.header
          $scope.template.headerPhotos.splice(index, 1)
        else
          $scope.template.footerPhotos.splice(index, 1)
        # $scope.templates.splice(index, 1)
        # $scope.template = $scope.templates[0]
      ), (error) ->
        console.log error.data
        return
      return
    ), (btn) ->
      return
