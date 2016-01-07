class AddFlawToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :flaw_id, :integer
    add_index :orders, :flaw_id
  end
end
