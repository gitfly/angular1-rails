class AddWorkerReworkToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :worker_rework, :boolean, default: false
  end
end
