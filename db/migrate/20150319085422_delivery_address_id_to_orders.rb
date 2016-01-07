class DeliveryAddressIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_address_id, :integer
    add_index :orders, :delivery_address_id
  end
end
