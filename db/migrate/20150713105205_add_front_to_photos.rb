class AddFrontToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :front, :boolean
  end
end
