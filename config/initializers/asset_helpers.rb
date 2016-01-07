require Rails.root.join('app', 'helpers', 'assets_helper.rb')

Rails.application.assets.context_class.class_eval do
  include ActionView::Helpers
  # include ActionView::Context
  include Rails.application.routes.url_helpers
  include AssetsHelper
  include SimpleForm::ActionViewExtensions::FormHelper
  include ActionView::Helpers::RenderingHelper
end
