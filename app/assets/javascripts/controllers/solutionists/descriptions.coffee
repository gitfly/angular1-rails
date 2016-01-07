app = window.app

app.controller 'descriptionsCtrl', (
  $scope,
  Category,
  PhotoDesc,
  focus,
  dialogs,
  DescTag
) ->
  $scope.descs = []
  $scope.desc = {}
  $scope.descCount = 0
  $scope.perPage = 10
  $scope.currentPage = 1
  $scope.descType = 0

  $scope.getPageArray = (num) ->
    return new Array(num)

  $scope.updateOrCreate = (desc) ->

    if desc.symptom && desc.contentChanged || desc.content && desc.contentChanged
      desc.contentChanged = false
      content_arr = []
      if $scope.descType == 0
        if desc.symptom
          content_arr.push("<span class='highlighted-desc font-size14'>症状：</span>#{desc.symptom}")
        if desc.technology
          content_arr.push("<span class='highlighted-desc font-size14'>工艺：</span>#{desc.technology}")
        if desc.expect
          content_arr.push("<span class='highlighted-desc font-size14'>预期效果：</span>#{desc.expect}")
            
        desc.content = content_arr.join("<br/>")
      
      if desc.id
        new PhotoDesc(desc).update().then ((result) ->
          desc.valueChange = false
          $scope.alertWith("话术更新成功")
        ), (error) ->
          console.log error
          return
      else
        descObj = {}
        if $scope.descType == 3
          descObj = {dtype: 3, content: desc.content}
        else 
          descObj = {dtype: $scope.descType, content: desc.content,symptom: desc.symptom, technology: desc.technology, expect: desc.expect}
        
        new PhotoDesc(descObj).create().then ((result) ->
          $scope.desc = result
          # $scope.descs.splice(0, 0, result)
          $scope.descs[0] = result
          $scope.alertWith("话术保存成功")
        ), (error) ->
          console.log error

  $scope.addNewDesc = () ->
    $scope.desc = {}
    $scope.descs.unshift($scope.desc)
    focus("desc-symptom")

  getPhotoDesc = (data={})->
    data = _.extend({
      page: 0,
      dtype: $scope.descType,
      perPage: $scope.perPage,
    }, data)
    PhotoDesc.query(data).then ((results) ->
      $scope.descCount = results.count
      $scope.descs = results.descs
      $scope.desc = $scope.descs[0]
      $scope.initTags = results.initTags
      $scope.pageCount = parseInt($scope.descCount/$scope.perPage + 1)
      return
    ), (error) ->
      console.log error
      return

  getPhotoDesc()

  $scope.getPage = (index) ->
    $scope.currentPage = index
    getPhotoDesc(
      q: $scope.searchStr,
      page: index-1,
    )

  $scope.previousPage = () ->
    if $scope.currentPage > 1
      $scope.currentPage -= 1
      $scope.getPage($scope.currentPage)

  $scope.nextPage = () ->
    if $scope.currentPage < $scope.pageCount
      $scope.currentPage += 1
      $scope.getPage($scope.currentPage)


  $scope.descContentChange = (desc) ->
    desc.contentChanged = true

  $scope.selectDesc = (desc) ->
    $scope.desc = desc


  $scope.setDescType = (val) ->
    $scope.descType = val
    getPhotoDesc((dtype: val))

  $scope.mouseleaveTextarea = (desc) ->
    desc.edit = false
    if desc.valueChange
      new PhotoDesc(desc).update().then ((result) ->
        desc.valueChange = false
        $scope.alertWith("话术更新成功")
      ), (error) ->
        console.log error
        return

  $scope.descKeyPress = (desc, event) ->
    if event.keyCode == 13
      if event.ctrlKey || event.metaKey
        $scope.mouseleaveTextarea(desc)

  $scope.selectTagsFor = (option, tag) ->
    tag.names.push(option.name)
    tag.categoryIds.push(option.id)
    new DescTag(tag).update().then ((result) ->
      $scope.getOptionsFor(tag)
    ), (error) ->
      console.log error


  $scope.startToAddTag = (desc, tag) ->
    new DescTag({
      names: [tag.name],
      categoryIds: [tag.id],
      photoDescId: desc.id
    }).create().then ((result) ->
      if desc.tags
        desc.tags.push(result)
      $scope.getOptionsFor(result)
      $scope.showInitTags = false
    ), (error) ->
      console.log error


  updateDesc = (desc) ->
    new PhotoDesc(desc).update().then ((result) ->
      $scope.alertWith("话术更新成功")
    ), (error) ->
      console.log error
      return

  $scope.getOptionsFor = (tag) ->
    Category.query({categoryId: _.last(tag.categoryIds)}).then ((results) ->
      tag.options = results
      console.log results
      return
    ), (error) ->
      console.log error
      return

  $scope.updateTag = (index, tag) ->
    l = tag.names.length-index
    tag.names.splice(index+1, l)
    tag.categoryIds.splice(index+1, l)
    tag.hideOptions = false
    new DescTag(tag).update().then ((result) ->
      $scope.getOptionsFor(tag)
    ), (error) ->
      console.log error

  $scope.searchStringChange = (searchStr) ->

  $scope.performSearch = (event, searchStr) ->
    if event.charCode == 13
      getPhotoDesc(
        dtype: $scope.descType,
        q: searchStr
      )


  $scope.deleteDesc = (desc, index) ->
    dialogs.confirm(
      '', "确定删除该话术吗？", {size: 'md'}
    ).result.then ((btn) ->
      new PhotoDesc(desc).remove().then ((result) ->
        $scope.descs.splice(index, 1)
      ), (error) ->
        console.log error
    ), (btn) ->
      return

  $scope.addNewTagList = () ->
    $scope.showInitTags = true

  $scope.removeTags = (tag, desc, i) ->
    desc.tags.splice(i, 1)

    new DescTag(tag).remove().then ((result) ->
      $scope.alertWith("删除成功！")
    ), (error) ->
      console.log error
