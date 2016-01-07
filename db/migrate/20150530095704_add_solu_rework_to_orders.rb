class AddSoluReworkToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :solu_rework, :boolean, default: false
  end
end
