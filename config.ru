# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'grape/rabl'

use Rack::Config do |env|
  env['api.tilt.root'] = 'lib/api/v1/views'
end


run Rails.application

# enable template caching:
Grape::Rabl.configure do |config|
  config.cache_template_loading = true unless Rails.env.development?
end
