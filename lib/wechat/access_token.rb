module Wechat
  class AccessToken < Base
    def self.fetch
      get '/cgi-bin/token', {
        without_token: true,
        appid: Settings.wechat.app_id, 
        grant_type: 'client_credential', 
        secret: Settings.wechat.app_secret
      }
    end
  end
end
