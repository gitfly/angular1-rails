class CreateWeixinAccounts < ActiveRecord::Migration
  def change
    create_table :weixin_accounts do |t|
      t.string :open_id
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :weixin_accounts, :open_id
    add_index :weixin_accounts, :user_id
  end
end
