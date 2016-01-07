app = window.app

app.controller 'AuthCtrl', ($scope, AccessToken, Rails) ->

  $scope.loginUrl =
    "http://182.92.156.241/oauth/authorize?response_type=token&client_id=#{Rails.app_id}&redirect_uri=http://#{Rails.host}"

  $scope.logout = ->
    User.logout().then ->
      AccessToken.delete()
      setLoggedIn false
      $state.go 'home'

  setLoggedIn = (isLoggedIn) ->
    $scope.loggedIn = !!isLoggedIn

  setLoggedIn AccessToken.get()
