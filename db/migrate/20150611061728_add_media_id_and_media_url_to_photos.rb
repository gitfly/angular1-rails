class AddMediaIdAndMediaUrlToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :media_id, :string
    add_column :photos, :media_url, :string
  end
end
