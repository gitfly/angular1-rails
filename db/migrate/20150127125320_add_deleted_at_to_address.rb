class AddDeletedAtToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :deleted_at, :datetime
    add_index :addresses, :deleted_at
  end
end
