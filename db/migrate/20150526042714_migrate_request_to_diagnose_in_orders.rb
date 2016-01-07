class MigrateRequestToDiagnoseInOrders < ActiveRecord::Migration
  def change
    Order.find_in_batches do |orders|
      orders.each do |order|
        order.update_attributes!(diagnose: order.request)
      end
    end
  end
end
