class AddCustomerIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :customer_id, :integer
    add_index :items, :customer_id
  end
end
