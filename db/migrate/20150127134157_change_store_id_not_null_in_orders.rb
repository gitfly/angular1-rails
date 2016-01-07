class ChangeStoreIdNotNullInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :store_id, :integer, :null => false
  end
end
