class AddHourAttributesToOrders < ActiveRecord::Migration

  def change
    add_column :orders, :fetch_hour_start, :string
    add_column :orders, :fetch_hour_end, :string
    add_column :orders, :delivery_hour_start, :string
    add_column :orders, :delivery_hour_end, :string
  end
end
