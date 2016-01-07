class AddRefundToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :refunded, :boolean, default: false
  end
end
