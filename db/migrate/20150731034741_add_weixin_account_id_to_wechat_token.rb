class AddWeixinAccountIdToWechatToken < ActiveRecord::Migration
  def change
    add_column :wechat_tokens, :weixin_account_id, :integer
    add_index :wechat_tokens, :weixin_account_id
  end
end
