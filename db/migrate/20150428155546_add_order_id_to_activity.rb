class AddOrderIdToActivity < ActiveRecord::Migration
  def change
    add_column :activity_codes, :order_id, :integer
    add_index :activity_codes, :order_id
  end
end
