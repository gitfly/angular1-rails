class AddDeletedAtToOrderStatuses < ActiveRecord::Migration
  def change
    add_column :order_statuses, :deleted_at, :datetime
    add_index :order_statuses, :deleted_at
  end
end
