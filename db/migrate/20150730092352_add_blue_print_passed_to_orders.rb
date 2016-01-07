class AddBluePrintPassedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :blue_print_passed, :boolean
  end
end
