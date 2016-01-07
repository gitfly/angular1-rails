class AddDeletedAtToMaintainPart < ActiveRecord::Migration
  def change
    add_column :maintain_parts, :deleted_at, :integer
    add_index :maintain_parts, :deleted_at
  end
end
