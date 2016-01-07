class AddIndexToStatusUpdatedAtToOrders < ActiveRecord::Migration
  def change
    add_index :orders, :status_updated_at
  end
end
