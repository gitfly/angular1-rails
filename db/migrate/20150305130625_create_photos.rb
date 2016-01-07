class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.attachment :photo
      t.integer :order_id

      t.timestamps null: false
    end
    add_index :photos, :order_id
  end
end
