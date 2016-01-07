class CreateOrderLogs < ActiveRecord::Migration
  def change
    create_table :order_logs do |t|
      t.integer :order_id
      t.integer :user_id
      t.string :attrs
      t.string :handle_type

      t.timestamps null: false
    end
    add_index :order_logs, :order_id
    add_index :order_logs, :user_id
  end
end
