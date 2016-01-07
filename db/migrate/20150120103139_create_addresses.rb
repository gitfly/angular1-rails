class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :addressable_id
      t.string  :addressable_type
      t.string :country, default: ""
      t.string :province, default: ""
      t.string :city, default: ""
      t.string :district, default: ""
      t.string :details, default: "" 

      t.timestamps null: false
    end
    add_index :addresses, [:addressable_id, :addressable_type]
  end
end
