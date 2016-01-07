class CreateConsumptionRecords < ActiveRecord::Migration
  def change
    create_table :consumption_records do |t|
      t.integer :customer_id
      t.integer :amount, default: 0
      t.integer :payment_method

      t.timestamps null: false
    end
    add_index :consumption_records, :customer_id
  end
end
