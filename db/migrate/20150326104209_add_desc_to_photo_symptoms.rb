class AddDescToPhotoSymptoms < ActiveRecord::Migration
  def change
    add_column :photo_symptoms, :desc, :text
  end
end
