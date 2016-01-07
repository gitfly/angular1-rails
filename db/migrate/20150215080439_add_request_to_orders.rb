class AddRequestToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :request, :text
  end
end
