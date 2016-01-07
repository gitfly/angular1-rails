class AddRemarkToConsumptionRecords < ActiveRecord::Migration
  def change
    add_column :consumption_records, :remark, :text
  end
end
