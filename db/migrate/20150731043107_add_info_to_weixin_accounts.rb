class AddInfoToWeixinAccounts < ActiveRecord::Migration
  def change
    add_column :weixin_accounts, :user_info, :text
  end
end
