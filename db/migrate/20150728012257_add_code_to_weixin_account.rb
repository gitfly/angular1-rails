class AddCodeToWeixinAccount < ActiveRecord::Migration
  def change
    add_column :weixin_accounts, :code, :string
    add_index :weixin_accounts, :code
  end
end
