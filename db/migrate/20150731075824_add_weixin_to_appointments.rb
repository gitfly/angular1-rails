class AddWeixinToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :weixin, :string
  end
end
