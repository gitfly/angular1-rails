class AddAbnormalToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :abnormal, :boolean, default: false
  end
end
