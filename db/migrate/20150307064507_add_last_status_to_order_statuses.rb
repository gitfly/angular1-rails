class AddLastStatusToOrderStatuses < ActiveRecord::Migration
  def change
    add_column :order_statuses, :last_status, :integer
  end
end
