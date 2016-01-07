class AddActRecordIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :act_record_id, :integer
    add_index :orders, :act_record_id
  end
end
