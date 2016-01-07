class ChangeCustomerIdNotNullInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :customer_id, :integer, :null => false
  end
end
