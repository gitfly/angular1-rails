class AddFinalPriceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :final_price, :integer
  end
end
