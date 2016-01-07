require 'templates_paths'

module JsEnv
  extend ActiveSupport::Concern
  include TemplatesPaths

  included do
    helper_method :js_env
  end

  def js_env
    data = {
      env: Rails.env,
      roles: User::Roles,
      host: Settings.host,
      templates: templates,
      app_id: Settings.app_id,
      app_secret: Settings.app_secret,
      orderSearchType: Order::SearchType,
      zhOrderStatuses: OrderStatus.zh_statuses,
      currentUser: env['warden'].try(:user).try(:front_end_attributes),
      loginUrl: "http://#{Settings.host}/oauth/authorize?response_type"\
        "=token&client_id=#{Settings.app_id}&redirect_uri=http://#{Settings.host}"
    }

    <<-EOS.html_safe
      <script type="text/javascript">
        app = window.app
        app.constant('Rails', #{data.to_json})
      </script>
    EOS
  end
end

# app/assets/javascripts/controllers/pages_ctrl.coffee
# angular.module('Baozheng').controller 'PagesCtrl', ($scope, Rails) ->
  # $scope.test = Rails.env
