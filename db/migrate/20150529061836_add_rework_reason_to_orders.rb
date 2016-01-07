class AddReworkReasonToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :rework_reason, :text
  end
end
