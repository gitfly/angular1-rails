class AddUsedToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :used, :boolean, default: true
    add_index :photos, :used
  end
end
