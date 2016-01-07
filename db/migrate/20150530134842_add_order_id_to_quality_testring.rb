class AddOrderIdToQualityTestring < ActiveRecord::Migration
  def change
    add_column :quality_testings, :order_id, :integer
    add_index :quality_testings, :order_id
  end
end
