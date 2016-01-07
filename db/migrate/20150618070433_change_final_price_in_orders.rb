class ChangeFinalPriceInOrders < ActiveRecord::Migration
  def up
    Order.where(paid: false).find_in_batches do |orders|
      orders.each do |order|
        order.final_price = order.calculate_final_price
        order.save!
      end
    end
  end

  def down
  end
end
