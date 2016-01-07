class AddTroubleToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :trouble, :boolean, default:false
    add_column :appointments, :trouble_desc, :string
    add_column :appointments, :trouble_type, :integer
  end
end
