class AddOrderIdCustomerIdToCompensate < ActiveRecord::Migration
  def change
    add_column :compensates, :order_id, :integer
    add_index :compensates, :order_id
    add_column :compensates, :customer_id, :integer
    add_index :compensates, :customer_id
  end
end
