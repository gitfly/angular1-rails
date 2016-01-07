class CreateOrderStatuses < ActiveRecord::Migration
  def change
    create_table :order_statuses do |t|
      t.integer :status, default: 0
      t.integer :order_id

      t.timestamps null: false
    end
    add_index :order_statuses, :order_id
  end
end
