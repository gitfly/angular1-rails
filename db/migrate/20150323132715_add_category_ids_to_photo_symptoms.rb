class AddCategoryIdsToPhotoSymptoms < ActiveRecord::Migration
  def change
    add_column :photo_symptoms, :category_ids, :string
  end
end
