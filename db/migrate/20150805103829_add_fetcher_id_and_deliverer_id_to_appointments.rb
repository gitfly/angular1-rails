class AddFetcherIdAndDelivererIdToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :fetcher_id, :integer
    add_index :appointments, :fetcher_id
    add_column :appointments, :deliverer_id, :integer
    add_index :appointments, :deliverer_id
  end
end
