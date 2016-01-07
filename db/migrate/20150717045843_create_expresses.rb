class CreateExpresses < ActiveRecord::Migration
  def change
    create_table :expresses do |t|
      t.integer :expressable_id
      t.string :expressable_type
      t.integer :company_type
      t.string :number
      t.integer :price
      t.boolean :cash_on_delivery

      t.timestamps null: false
    end
    add_index :expresses, :expressable_id
  end
end
