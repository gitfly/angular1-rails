class AddGiftToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :gift, :string
  end
end
