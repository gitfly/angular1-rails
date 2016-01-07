class AddFriendIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :friend_id, :integer
    add_index :orders, :friend_id
  end
end
