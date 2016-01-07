class RemoveAmountFromConsumptionRecords < ActiveRecord::Migration
  def change
    remove_column :consumption_records, :amount
  end
end
