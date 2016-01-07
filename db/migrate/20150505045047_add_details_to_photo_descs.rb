class AddDetailsToPhotoDescs < ActiveRecord::Migration
  def change
    add_column :photo_descs, :symptom, :string
    add_column :photo_descs, :technology, :string
    add_column :photo_descs, :expect, :string
  end
end
