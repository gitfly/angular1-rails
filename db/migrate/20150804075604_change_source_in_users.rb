class ChangeSourceInUsers < ActiveRecord::Migration
  def change
    add_column :users, :sub_source, :string
    change_column :users, :source, :string
  end
end
