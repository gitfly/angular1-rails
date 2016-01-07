class ChangeColorOpenIdToOpenidInWeixinAccount < ActiveRecord::Migration
  def change
    remove_column :weixin_accounts, :open_id
    add_column :weixin_accounts, :openid, :string
  end
end
