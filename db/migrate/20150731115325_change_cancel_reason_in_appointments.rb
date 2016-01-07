class ChangeCancelReasonInAppointments < ActiveRecord::Migration
  def change
    change_column :appointments, :cancel_reason, :text
  end
end
