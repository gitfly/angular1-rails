app = window.app

app.controller "activitiesCtrl", (
  $scope,
  Activity,
  $window,
  dialogs,
  $anchorScroll
) ->

  $scope.activities = []
  $scope.showForm = false
  $scope.activity = {
    atype: 0,
    addup: 'false',
    consumeAddUp: 1,
    discountManner: '1'
  }

  $scope.itemTypes = {
    "全部物品": 0
    "钱包": 1
    "手提包": 2
    "单肩包": 3
    "双肩包": 4
    "皮带": 5
    "鞋子": 6
    "皮衣": 7
    "钥匙包": 8
    "卡包": 9
    "皮手套": 10
    "手表带": 11
    "短靴": 12
    "长靴": 13
    "过膝长靴": 14
    "皮马甲": 15
    "肩带": 16
    "行李箱": 17
    "皮草": 18
    "帽子": 19
    "化妆包": 20
    "手机套": 21
  }

  $scope.itemTypesKeys = _.keys($scope.itemTypes)

  Activity.query({}).then ((results) ->
    $scope.activities = results
  ), (error) ->
    console.log error


  $scope.acFormCanSubmit = true
  $scope.createNewActivity = (activity) ->
    $scope.acFormCanSubmit = false
    if activity.atype == '0' || activity.atype=='3'
      activity.discountManner = 1
    new Activity(activity).create().then ((result) ->
      console.log result
      $scope.acFormCanSubmit = true
      $window.scrollTo(0,0)
      $scope.showForm = false
      $scope.activities.unshift(result)
      $scope.activity = {}
      $scope.alertWith("活动创建成功")
    ), (error) ->
      console.log error.data

  $scope.updateActivity = (activity) ->
    $scope.acFormCanSubmit = false
    new Activity(activity).update().then ((result) ->
      $scope.acFormCanSubmit = true
      $window.scrollTo(0,0)
      $scope.showForm = false
      $scope.activities[activity.index] = result
      $scope.alertWith("活动创建成功")
      $scope.activity = {}
    ), (error) ->
      console.log error.data

  $scope.changeFormStatus = (val) ->
    $scope.showForm = val
    unless val
      $scope.activity = {
        addup: 'false',
        discountManner: '1'
      }

  $scope.editActivity = (ac, index) ->
    if ac.addup
      ac.addup = 1
    else
      ac.addup = 0
    $scope.activity = ac
    $scope.activity.index = index
    $scope.showForm = true

  $scope.deleteActivity = (ac, index) ->
    dialogs.confirm('', "确定删除该活动吗", {size: 'md'}).result.then (btn) ->
      new Activity(ac).remove().then ((result) ->
        $scope.activities.splice(index, 1)
        $scope.alertWith("活动#{ac.name}删除成功")
      ), (error) ->
        console.log error.data
      return
    
  $scope.endActivity = (ac, index) ->
    dialogs.confirm('', "确定结束该活动吗", {size: 'md'}).result.then (btn) ->
      ac.endDate = moment().subtract(1, 'days').format('YYYY-MM-DD')
      new Activity(ac).update().then ((result) ->
        $scope.activities[index] = result
        $scope.alertWith("活动#{ac.name}删除成功")
      ), (error) ->
        console.log error.data
      return

  $scope.atypeChange = (activity) ->
    if activity.atype == '0' || activity.atype == '3'
      activity.addUp = 'false'
      activity.discountManner = 1

