class AddDeliveryNameAndDeliveryPhoneToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_name, :string
    add_column :orders, :delivery_phone, :string
  end
end
