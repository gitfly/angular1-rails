class AddActivityIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :activity_id, :integer
    add_index :orders, :activity_id
  end
end
