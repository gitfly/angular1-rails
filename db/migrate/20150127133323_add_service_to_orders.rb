class AddServiceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :service_id, :integer
    add_index :orders, :service_id
  end
end
