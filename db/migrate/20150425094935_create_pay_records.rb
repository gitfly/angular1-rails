class CreatePayRecords < ActiveRecord::Migration
  def change
    create_table :pay_records, :force => true do |t|
      t.integer :pm
      t.integer :amount
      t.text :content
      t.integer :member_id
      t.integer :settlement_id

      t.timestamps null: false
    end
    add_index :pay_records, :settlement_id
  end
end
