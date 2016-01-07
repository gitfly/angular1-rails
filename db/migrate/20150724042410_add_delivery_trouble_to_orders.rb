class AddDeliveryTroubleToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_trouble, :boolean, default:false
    add_column :orders, :delivery_trouble_type, :integer
    add_column :orders, :delivery_trouble_desc, :string
  end
end
