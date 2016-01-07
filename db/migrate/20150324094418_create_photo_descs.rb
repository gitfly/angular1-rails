class CreatePhotoDescs < ActiveRecord::Migration
  def change
    create_table :photo_descs do |t|
      t.text :content
      t.string :tags

      t.timestamps null: false
    end
    add_index :photo_descs, :tags
  end
end
