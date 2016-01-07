class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.string :name
      t.string :phone
      t.string :weixin
      t.integer :customer_id

      t.timestamps null: false
    end
    add_index :friends, :customer_id
  end
end
