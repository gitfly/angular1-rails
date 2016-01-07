class AddFinishDateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :finish_date, :date
  end
end
