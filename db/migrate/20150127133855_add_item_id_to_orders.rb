class AddItemIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :item_id, :integer
    add_index :orders, :item_id
  end
end
