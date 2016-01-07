class AddServiceIdsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :service_ids, :string, default: ''
  end
end
