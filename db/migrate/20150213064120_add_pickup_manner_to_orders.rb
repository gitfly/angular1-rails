class AddPickupMannerToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :pickup_manner, :integer, default: 0
    change_column :orders, :delivery_manner, :integer, default: 0
  end
end
