class CreateWechatTokens < ActiveRecord::Migration
  def change
    create_table :wechat_tokens do |t|
      t.string :access_token
      t.integer :expires_in
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
