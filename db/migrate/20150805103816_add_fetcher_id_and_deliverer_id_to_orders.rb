class AddFetcherIdAndDelivererIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :fetcher_id, :integer
    add_index :orders, :fetcher_id
    add_column :orders, :deliverer_id, :integer
    add_index :orders, :deliverer_id
  end
end
