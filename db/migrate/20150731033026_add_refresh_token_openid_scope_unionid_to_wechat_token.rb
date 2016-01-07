class AddRefreshTokenOpenidScopeUnionidToWechatToken < ActiveRecord::Migration
  def change
    add_column :wechat_tokens, :refresh_token, :string
    add_column :wechat_tokens, :openid, :string
    add_column :wechat_tokens, :scope, :string
    add_column :wechat_tokens, :unionid, :string
  end
end
