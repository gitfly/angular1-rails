class AddAtypeToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :atype, :integer
  end
end
