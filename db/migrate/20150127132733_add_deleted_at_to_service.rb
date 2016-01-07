class AddDeletedAtToService < ActiveRecord::Migration
  def change
    add_column :services, :deleted_at, :integer
    add_index :services, :deleted_at
  end
end
