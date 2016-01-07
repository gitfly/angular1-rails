class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  respond_to :json, :html, :js, :mobile, :tablet
  # protect_from_forgery with: :exception

  include JsEnv

  layout :layout_by_resource

  before_action :authenticate_user!

  before_action :set_request_format
  has_mobile_fu false

  before_action :filter_user

  private

  def set_request_format
    unless request.xhr?
      if is_tablet_device? || is_mobile_device?
        request.format = :mobile
      end
    end
  end

  def filter_user
    if current_user && !current_user.approved
      raise 'error'
    end
  end

  def layout_by_resource
    # 'mobile'
    if is_mobile_device? || is_tablet_device?
      'mobile'
    else
      if devise_controller?
        'devise'
      else
        "application"
      end
    end
  end
end


# class AssetViewHelper::Railtie < ::Rails::Railtie
#   initializer "asset_hel" do |app|
#     ActiveSupport.on_load :action_view do
#       include MyGem::ActionView::Helpers
#     end
# 
#     ActiveSupport.on_load :action_controller do
#       include MyGem::ActionController::Filters
#     end
#   end
# end
