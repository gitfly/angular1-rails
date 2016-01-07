class AddFinishedToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :finished, :boolean, default: false
  end
end
