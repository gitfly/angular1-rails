class AddAppointmentIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :appointment_id, :integer
    add_index :orders, :appointment_id
  end
end
