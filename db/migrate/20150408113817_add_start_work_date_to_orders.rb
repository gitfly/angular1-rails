class AddStartWorkDateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :start_work_date, :date
  end
end
