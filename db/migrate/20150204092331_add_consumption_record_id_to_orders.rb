class AddConsumptionRecordIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :consumption_record_id, :integer
    add_index :orders, :consumption_record_id
  end
end
