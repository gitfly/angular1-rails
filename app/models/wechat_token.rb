class WechatToken < ActiveRecord::Base
  include Wechat::Wechatable
  belongs_to :weixin_account

  acts_as_paranoid

  def expired?
    self.expires_in.nil? and return true
    Time.now -  self.created_at > self.expires_in
  end

  def self.get_token
    @token ||= self.where(weixin_account_id: nil).last
    regenerate_token if @token.nil? || @token.expired?
    @token
  end

  def self.get_token_by_code(code)
    response = post('/sns/oauth2/access_token', {
      code: code,
      without_token: true,
      appid: Settings.wechat.app_id, 
      grant_type: 'authorization_code', 
      secret: Settings.wechat.app_secret
    })
    token = self.new response
    token.weixin_account = WeixinAccount.where(
      openid: token.openid
    ).first_or_create!(code: code)
    if token.weixin_account.code != code
      token.weixin_account.update!(code: code)
    end
    token.save! and token
  end

  def self.regenerate_token
    self.where(weixin_account_id: nil).last.try(:destroy)
    @token = self.create!
    @token.update_attributes!(Wechat::AccessToken.fetch)
  end
end
