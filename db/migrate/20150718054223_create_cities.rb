class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :province_id

      t.timestamps null: false
    end
    add_index :cities, :province_id
  end
end
