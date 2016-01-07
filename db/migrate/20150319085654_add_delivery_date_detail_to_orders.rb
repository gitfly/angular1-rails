class AddDeliveryDateDetailToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_date_detail, :string
  end
end
