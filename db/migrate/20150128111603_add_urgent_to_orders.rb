class AddUrgentToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :urgent, :boolean, default: false
    add_index :orders, :urgent
  end
end
