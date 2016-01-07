class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :number
      t.date :receive_date
      t.integer :store_id
      t.integer :customer_id
      t.date :delivery_date
      t.boolean :delivery_manner

      t.timestamps null: false
    end
    add_index :orders, :receive_date
    add_index :orders, :delivery_date
    add_index :orders, :number
    add_index :orders, :store_id
  end
end
