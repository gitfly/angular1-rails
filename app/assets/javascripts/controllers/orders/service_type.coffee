app = window.app

app.controller 'serviceType', (
  $scope,
  Service
) ->

  $scope.services = []
  $scope.currentService = {}
  $scope.addNewService = false

  Service.query({}).then ((results) ->
    $scope.services = results
  ), (error) ->
    console.log error

  $scope.changeNewServiceStatus = (val) ->
    $scope.addNewService = val

  $scope.createService = (service) ->
    new Service(service).create().then ((result) ->
      $scope.services.unshift(result)
      $scope.currentService = {}
      $scope.addNewService = false
    ), (error) ->
      console.log error

  $scope.deleteService = (service) ->
    new Service(service).remove().then ((result) ->
      $scope.services = _.without($scope.services, service)
    ), (error) ->
      console.log error
