class AddBirthdayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :date
    add_column :users, :weixin_nickname, :string
  end
end
