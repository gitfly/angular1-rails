class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :customer_id
      t.date :date

      t.timestamps null: false
    end
    add_index :appointments, :customer_id
  end
end
