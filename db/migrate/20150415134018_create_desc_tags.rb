class CreateDescTags < ActiveRecord::Migration
  def change
    create_table :desc_tags do |t|
      t.string :names
      t.string :category_ids
      t.integer :photo_desc_id

      t.timestamps null: false
    end
    add_index :desc_tags, :photo_desc_id
  end
end
