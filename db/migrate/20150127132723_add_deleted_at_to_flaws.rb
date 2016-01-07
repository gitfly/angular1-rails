class AddDeletedAtToFlaws < ActiveRecord::Migration
  def change
    add_column :flaws, :deleted_at, :integer
    add_index :flaws, :deleted_at
  end
end
