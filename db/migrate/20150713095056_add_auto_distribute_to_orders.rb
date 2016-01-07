class AddAutoDistributeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :auto_distribute, :boolean, default: false
  end
end
