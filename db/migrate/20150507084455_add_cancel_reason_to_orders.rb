class AddCancelReasonToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :cancel_reason, :text
  end
end
