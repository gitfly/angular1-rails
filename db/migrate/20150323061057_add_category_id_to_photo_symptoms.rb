class AddCategoryIdToPhotoSymptoms < ActiveRecord::Migration
  def change
    add_column :photo_symptoms, :categoty_id, :integer
    add_index :photo_symptoms, :categoty_id
  end
end
