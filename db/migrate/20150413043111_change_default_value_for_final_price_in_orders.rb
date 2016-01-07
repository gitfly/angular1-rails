class ChangeDefaultValueForFinalPriceInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :final_price, :integer, default: 0
  end
end
