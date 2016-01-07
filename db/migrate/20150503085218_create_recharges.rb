class CreateRecharges < ActiveRecord::Migration
  def change
    create_table :recharges do |t|
      t.integer :amount, default: 0
      t.integer :bonus, default: 0
      t.integer :customer_id
      t.text :content
      t.integer :pm
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :recharges, :customer_id
    add_index :recharges, :user_id
  end
end
