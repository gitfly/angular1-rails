class AddHeaderToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :header, :boolean, default: true
  end
end
