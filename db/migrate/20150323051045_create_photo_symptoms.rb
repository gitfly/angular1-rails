class CreatePhotoSymptoms < ActiveRecord::Migration
  def change
    create_table :photo_symptoms do |t|
      t.string :symptoms
      t.integer :photo_id

      t.timestamps null: false
    end
    add_index :photo_symptoms, :photo_id
  end
end
