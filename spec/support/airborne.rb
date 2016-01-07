require 'airborne'

Airborne.configure do |config|
  config.rack_app = API::Root

  # config.base_url = 'http://baozheng.com:3000/api/v1'
  # config.headers = {'x-auth-token' => 'my_token'}
end
