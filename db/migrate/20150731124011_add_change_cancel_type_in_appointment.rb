class AddChangeCancelTypeInAppointment < ActiveRecord::Migration
  def change
    change_column :appointments, :cancel, :boolean, default: false
  end
end
