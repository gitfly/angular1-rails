class WeixinAccount < ActiveRecord::Base
  include Wechat::Wechatable

  serialize :user_info, Hash
  
  belongs_to :user
  has_many :wechat_tokens

  # before_create do |record|
  #   record.code = SecureRandom.hex(32)
  # end

  def self.fetch_user_info(code)
    token = self.get_token_by_code(code)
  end

  def access_token
    wechat_tokens.last.access_token
  end

  def get_user_info
    user_info.present? and return
    info = self.class.post '/sns/userinfo', { 
      openid: openid, 
      without_token: true, 
      access_token: access_token 
    }
    update!(user_info: info)
  end
end
