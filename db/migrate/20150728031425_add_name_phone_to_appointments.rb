class AddNamePhoneToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :name, :string
    add_column :appointments, :phone, :string
    add_index :appointments, :phone
  end
end
