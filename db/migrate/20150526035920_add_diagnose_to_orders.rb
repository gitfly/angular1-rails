class AddDiagnoseToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :diagnose, :text
  end
end
