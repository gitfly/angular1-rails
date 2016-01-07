class AddValidToOrderStatuses < ActiveRecord::Migration
  def change
    add_column :order_statuses, :forward, :boolean, default: true
  end
end
