class AddDateDetailToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :date_detail_start, :string
    add_column :appointments, :date_detail_end, :string
  end
end
