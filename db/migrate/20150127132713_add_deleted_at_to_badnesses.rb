class AddDeletedAtToBadnesses < ActiveRecord::Migration
  def change
    add_column :badnesses, :deleted_at, :integer
    add_index :badnesses, :deleted_at
  end
end
