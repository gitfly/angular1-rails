load 'lib/dirty.rb'

module API
  class Root < Grape::API
    format :json
    formatter :json, Grape::Formatter::Rabl
    # use ::WineBouncer::OAuth2
    prefix :api

    mount API::V1::Root
  end
end
