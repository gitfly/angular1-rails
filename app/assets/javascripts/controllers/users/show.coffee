window.app.controller('UsersShowController', ($scope, $routeParams, User) ->
  $scope.pageClass = 'user-show'
  User.get(1).then((user) ->
    $user = user
    console.log $user
  )
)
