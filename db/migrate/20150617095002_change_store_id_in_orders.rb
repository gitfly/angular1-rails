class ChangeStoreIdInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :store_id, :integer, default: 1
  end
  
end
