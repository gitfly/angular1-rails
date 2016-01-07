class CreateSettlements < ActiveRecord::Migration
  def change
    create_table :settlements, :force =>true do |t|
      t.integer :amount
      t.integer :customer_id
      t.integer :user_id
      t.integer :order_id

      t.timestamps null: false
    end
    add_index :settlements, :customer_id
    add_index :settlements, :user_id
    add_index :settlements, :order_id
  end
end
