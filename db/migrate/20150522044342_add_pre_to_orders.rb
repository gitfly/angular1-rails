class AddPreToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :pre, :boolean, default: false
    add_index :orders, :pre
  end
end
