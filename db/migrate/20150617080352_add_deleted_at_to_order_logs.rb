class AddDeletedAtToOrderLogs < ActiveRecord::Migration
  def change
    add_column :order_logs, :deleted_at, :datetime
    add_index :order_logs, :deleted_at
  end
end
