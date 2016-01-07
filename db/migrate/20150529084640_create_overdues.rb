class CreateOverdues < ActiveRecord::Migration
  def change
    create_table :overdues do |t|
      t.date :original_date
      t.date :expected_date
      t.string :reason
      t.integer :operator_id
      t.references :order, index: true

      t.timestamps null: false
    end
    add_foreign_key :overdues, :orders
  end
end
