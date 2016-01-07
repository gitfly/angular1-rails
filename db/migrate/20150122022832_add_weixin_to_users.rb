class AddWeixinToUsers < ActiveRecord::Migration
  def change
    add_column :users, :weixin, :string, default: ""
  end
end
