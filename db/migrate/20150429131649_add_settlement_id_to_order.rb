class AddSettlementIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :settlement_id, :integer
    add_index :orders, :settlement_id
  end
end
