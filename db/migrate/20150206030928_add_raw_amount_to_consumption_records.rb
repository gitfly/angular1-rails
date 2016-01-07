class AddRawAmountToConsumptionRecords < ActiveRecord::Migration
  def change
    add_column :consumption_records, :raw_amount, :integer, default: 0
  end
end
