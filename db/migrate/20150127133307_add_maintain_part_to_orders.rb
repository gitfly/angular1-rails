class AddMaintainPartToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :maintain_part_id, :integer
    add_index :orders, :maintain_part_id
  end
end
