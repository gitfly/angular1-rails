class AddGenderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender, :boolean, default: false
    add_index :users, :gender
  end
end
