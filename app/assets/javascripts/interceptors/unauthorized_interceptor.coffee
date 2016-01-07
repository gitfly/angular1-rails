app = window.app

app.factory 'unauthorizedInterceptor', ($q, $injector, $window, Rails) ->
  return (promise) ->
    success = (response) -> response
    error   = (response) ->
      if response.status == 401
        # $window.location.href = Rails.loginUrl
        $injector.get('$state').go('401', {tokenInvalid: true})
      $q.reject(response)

    promise.then success, error

app.config ($httpProvider) ->
  $httpProvider.responseInterceptors.push('unauthorizedInterceptor')
