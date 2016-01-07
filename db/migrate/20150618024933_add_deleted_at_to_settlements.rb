class AddDeletedAtToSettlements < ActiveRecord::Migration
  def change
    add_column :settlements, :deleted_at, :datetime
    add_index :settlements, :deleted_at
  end
end
