class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.string :item_type
      t.integer :discount_manner
      t.integer :amount
      t.text :content
      t.date :start_date
      t.date :end_date
      t.boolean :addup

      t.timestamps null: false
    end
  end
end
