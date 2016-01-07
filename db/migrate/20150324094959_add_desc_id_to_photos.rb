class AddDescIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :desc_id, :integer
    add_index :photos, :desc_id
  end
end
