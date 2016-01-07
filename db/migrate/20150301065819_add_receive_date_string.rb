class AddReceiveDateString < ActiveRecord::Migration
  def change
    add_column :orders, :receive_week, :string
    add_column :orders, :receive_day, :string
  end
end
