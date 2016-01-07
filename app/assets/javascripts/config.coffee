app = window.app

$.datepicker.setDefaults($.datepicker.regional[ "zh-CN" ])
$.extend $.datepicker, {
  _checkOffset: (inst,offset,isFixed) ->
    return offset
}

# config for file upload
app.config ($compileProvider) ->
  oldWhiteList = $compileProvider.imgSrcSanitizationWhitelist()
  $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|file|blob):|data:image\//)

# fix angularjs dynamic input name bug
app.config [
  '$provide'
  ($provide) ->
    $provide.decorator 'ngModelDirective', [
      '$delegate'
      ($delegate) ->
        ngModel = $delegate[0]
        controller = ngModel.controller
        ngModel.controller = [
          '$scope'
          '$element'
          '$attrs'
          '$injector'
          (scope, element, attrs, $injector) ->
            $interpolate = $injector.get('$interpolate')
            attrs.$set 'name', $interpolate(attrs.name or '')(scope)
            $injector.invoke controller, this,
              '$scope': scope
              '$element': element
              '$attrs': attrs
            return
        ]
        $delegate
    ]
    $provide.decorator 'formDirective', [
      '$delegate'
      ($delegate) ->
        form = $delegate[0]
        controller = form.controller
        form.controller = [
          '$scope'
          '$element'
          '$attrs'
          '$injector'
          (scope, element, attrs, $injector) ->
            $interpolate = $injector.get('$interpolate')
            attrs.$set 'name', $interpolate(attrs.name or attrs.ngForm or '')(scope)
            $injector.invoke controller, this,
              '$scope': scope
              '$element': element
              '$attrs': attrs
            return
        ]
        $delegate
    ]
    return
]









# With a JsEnv and small AngularJS interceptor we will always get the right path for our template, 
# even on production after the rake assets:precompile.
# Throughout the whole AngularJS application we can use asset paths normally like: /pages/index.html. 
# The railsAssetsInterceptor factory will translate asset paths to their version after compilation. 
# It changes the asset path from /pages/index.html to /assets/pages/index-sha.html.
# 

# app.config ($provide, $httpProvider, Rails) ->
#   # Assets interceptor
#   $provide.factory 'railsAssetsInterceptor', ($angularCacheFactory) ->
#     request: (config) ->
#       if assetUrl = Rails.templates[config.url]
#         config.url = assetUrl
#       config
# 
#   $httpProvider.interceptors.push('railsAssetsInterceptor')
