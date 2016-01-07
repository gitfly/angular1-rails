class ChangeReceiveDateToFetchDateInOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :receive_date, :fetch_date
  end
end
