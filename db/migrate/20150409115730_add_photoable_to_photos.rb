class AddPhotoableToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :photoable_id, :integer
    add_index :photos, :photoable_id
    add_column :photos, :photoable_type, :string
  end
end
