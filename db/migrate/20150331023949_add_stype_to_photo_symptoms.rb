class AddStypeToPhotoSymptoms < ActiveRecord::Migration
  def change
    add_column :photo_symptoms, :stype, :boolean, default: false
    add_index :photo_symptoms, :stype
  end
end
