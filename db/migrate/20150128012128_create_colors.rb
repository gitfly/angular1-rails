class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string :name
      t.integer :value

      t.timestamps null: false
    end
    add_index :colors, :value
  end
end
