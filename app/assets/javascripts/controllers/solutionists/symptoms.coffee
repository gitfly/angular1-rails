app = window.app

app.controller 'symptomsCtrl', (
  $scope,
  Category,
  PhotoDesc,
  focus,
  dialogs
) ->

  $scope.items = []
  $scope.list = []
  $scope.itemIdsToDelete = []

  getInitData = (categoryId) ->
    Category.query({categoryId: categoryId}).then ((results) ->
      $scope.items = results
      return
    ), (error) ->
      console.log error
      return

  getInitData(0)

  $scope.editItem = (item) ->
    item.edit = true

  $scope.backToTop = () ->
    $scope.list = []
    getInitData(0)

  $scope.selectListItem = (item, index) ->
    $scope.list = _.first($scope.list, index)
    $scope.selectItem(item)

  $scope.selectItem = (item) ->
    item.selected = true
    if item.edit
      return

    $scope.list.push(item)
    if item.nodes && item.nodes.length
      $scope.items = item.nodes
    else
      Category.query({categoryId: item.recordId}).then ((results) ->
        $scope.items = results
        return
      ), (error) ->
        console.log error
        return

  $scope.inputKeyPress = (item, index, event) ->
    if event.keyCode == 13
      $scope.updateItem(item, index)

  $scope.itemNameChange = (item) ->
    item.nameChanged = true

  $scope.inputBlur = (item, index) ->
    if item.id
      $scope.updateItem(item, index)
    else
      $scope.items.splice(index, 1)

  $scope.updateItem = (item, index) ->
    unless item.name
      $scope.alertWith("症状名不能为空！", 'danger')
      return

    if item.id
      if item.nameChanged
        new Category(item).update().then (result) ->
          item.edit = false
          $scope.items[index] = item
          $scope.alertWith("症状更新成功！")
          item.nameChanged = false
        , (error) ->
          console.log error
      else
        item.edit = false
    else
      new Category(item).create().then (result) ->
        item = result
        item.edit = false
        $scope.items[index] = item
        $scope.createItem()
        $scope.alertWith("症状创建成功！")
      , (error) ->
        console.log error

  $scope.createItem = () ->
    if $scope.list.length
      parentId = _.last($scope.list).id
    else
      parentId = null
    $scope.items.push({
      edit: true,
      parentId: parentId
    })

  $scope.checkItem = (item) ->
    item.checked = !item.checked
    if item.checked
      $scope.itemIdsToDelete.push(item.id)

  $scope.deleteItems = (ids) ->
    if ids.length
      dialogs.confirm(
        '', "确定删除？", {size: 'md'}
      ).result.then (btn) ->
        new Category(id: ids).remove().then (result) ->
          $scope.alertWith("删除成功！")
          $scope.items = _.reject($scope.items, (item) ->
            return _.indexOf(ids, item.id) >= 0
          )
          $scope.itemIdsToDelete = []
        , (error) ->
          console.log error
    else
      $scope.alertWith("请先选择症状！", 'danger')






































  # $scope.remove = (scope) ->
  #   scope.remove()
  #   return

  # $scope.removeThisNode = (scope) ->
  #   nodeData = scope.$modelValue

  #   dialogs.confirm(
  #     '', "确定删除该节点吗？", {size: 'md'}
  #   ).result.then ((btn) ->

  #     new Category({id: nodeData.recordId}).delete().then ((result) ->
  #       # $scope.photos.splice(index, 1)
  #     ), (error) ->
  #       alert('error')
  #       return

  #     scope.remove()
  #     return
  #   ), (btn) ->
  #     return

  # $scope.toggleNode = (scope) ->
  #   nodeData = scope.$modelValue

  #   Category.query({categoryId: nodeData.recordId}).then ((results) ->
  #     scope.$modelValue.nodes = results
  #     return
  #   ), (error) ->
  #     alert('error')
  #     return

  #   scope.toggle()
  #   return

  # $scope.moveLastToTheBegginig = ->
  #   a = $scope.datas.pop()
  #   $scope.datas.splice 0, 0, a
  #   return

  # $scope.submitNewNode = (node, scope) ->
  #   node.edit = false
  #   nodeData = scope.$modelValue
  #   parentData = scope.$parentNodeScope.$modelValue

  #   new Category({name: nodeData.title, parentId: parentData.recordId}).create().then ((results) ->
  #     p_nodes = parentData.nodes
  #     parentData.nodes[p_nodes.length - 1].recordId = results.recordId
  #     return
  #   ), (error) ->
  #     alert('error')
  #     return

  # $scope.cancelNewNode = (node, scope) ->
  #   unless node.edit
  #     scope.remove()
  #   node.edit=false

  # $scope.newSubItem = (scope) ->
  #   nodeData = scope.$modelValue
  #   nodeData.nodes.push
  #     id: nodeData.id * 10 + nodeData.nodes.length
  #     title: nodeData.title + '.' + nodeData.nodes.length + 1
  #     edit: true
  #     nodes: []
  #   return

  # getRootNodesScope = ->
  #   angular.element(document.getElementById('tree-root')).scope()

  # $scope.collapseAll = ->
  #   scope = getRootNodesScope()
  #   scope.collapseAll()
  #   return

  # $scope.expandAll = ->
  #   scope = getRootNodesScope()
  #   scope.expandAll()
  #   return
