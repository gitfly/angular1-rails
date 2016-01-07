class AddCancelToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :cancel, :boolean
    add_column :appointments, :cancel_reason, :string
    add_column :appointments, :cancel_type, :integer
  end
end
