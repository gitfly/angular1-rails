class AddDtypeToPhotoDescs < ActiveRecord::Migration
  def change
    add_column :photo_descs, :dtype, :integer, default: 0
    add_index :photo_descs, :dtype
  end
end
