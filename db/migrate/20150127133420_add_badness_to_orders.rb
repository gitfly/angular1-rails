class AddBadnessToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :badness_id, :integer
    add_index :orders, :badness_id
  end
end
