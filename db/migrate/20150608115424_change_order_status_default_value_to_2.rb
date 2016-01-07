class ChangeOrderStatusDefaultValueTo2 < ActiveRecord::Migration
  def change
    change_column :orders, :status, :integer, default: 2
    change_column :order_statuses, :status, :integer, default: 2
  end
end
