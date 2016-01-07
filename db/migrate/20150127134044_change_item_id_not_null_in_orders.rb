class ChangeItemIdNotNullInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :item_id, :integer, :null => false
  end
end
