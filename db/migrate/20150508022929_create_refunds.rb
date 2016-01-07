class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.integer :pm
      t.integer :rtype
      t.integer :amount
      t.integer :order_id
      t.text :reason

      t.timestamps null: false
    end
    add_index :refunds, :order_id
  end
end
