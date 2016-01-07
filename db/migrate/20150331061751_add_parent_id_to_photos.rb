class AddParentIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :parent_id, :integer
    add_index :photos, :parent_id
  end
end
