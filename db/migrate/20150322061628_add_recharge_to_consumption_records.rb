class AddRechargeToConsumptionRecords < ActiveRecord::Migration
  def change
    add_column :consumption_records, :recharge, :boolean, default: false
  end
end
