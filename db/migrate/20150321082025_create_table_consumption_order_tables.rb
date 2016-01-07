class CreateTableConsumptionOrderTables < ActiveRecord::Migration
  def change
    create_table :consumption_records_orders, id: false do |t|
      t.belongs_to :consumption_record, index: true
      t.belongs_to :order, index: true
    end
  end
end
