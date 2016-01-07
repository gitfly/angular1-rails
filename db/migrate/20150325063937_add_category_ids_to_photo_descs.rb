class AddCategoryIdsToPhotoDescs < ActiveRecord::Migration
  def change
    add_column :photo_descs, :category_ids, :string
  end
end
