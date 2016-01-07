class AddCompensatedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :compensated, :boolean, default: false
  end
end
