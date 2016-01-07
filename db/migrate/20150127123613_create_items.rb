class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :type
      t.string :brand
      t.string :style
      t.string :color

      t.timestamps null: false
    end
    add_index :items, :type
    add_index :items, :brand
    add_index :items, :style
    add_index :items, :color
  end
end
