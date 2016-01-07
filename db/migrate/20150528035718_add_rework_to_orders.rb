class AddReworkToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :rework, :integer, default: 0
    add_index :orders, :rework
  end
end
