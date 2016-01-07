class AddDeliveryDateStartAndDeliveryDateEnd < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_date_start, :integer
    add_column :orders, :delivery_date_end, :integer
    add_column :orders, :delivery_week, :string
    add_column :orders, :delivery_day, :string
  end
end
