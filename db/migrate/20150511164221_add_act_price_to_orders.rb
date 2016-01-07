class AddActPriceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :act_price, :integer, default: 0
  end
end
