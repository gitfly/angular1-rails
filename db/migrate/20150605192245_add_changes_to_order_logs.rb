class AddChangesToOrderLogs < ActiveRecord::Migration
  def change
    add_column :order_logs, :changed_values, :text
  end
end
