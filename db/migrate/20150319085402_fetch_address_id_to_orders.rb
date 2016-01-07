class FetchAddressIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :fetch_address_id, :integer
    add_index :orders, :fetch_address_id
  end
end
