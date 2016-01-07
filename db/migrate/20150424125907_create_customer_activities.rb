class CreateCustomerActivities < ActiveRecord::Migration
  def up
    drop_table :customer_activities
  end
  def change
    create_table :customer_activities, :force =>true do |t|
      t.integer :customer_id
      t.integer :activity_id
      t.integer :order_count, default: 0

      t.timestamps null: false
    end
    add_index :customer_activities, [:customer_id, :activity_id]
    add_index :customer_activities, :activity_id
  end
end

