class AddScaleToOrders < ActiveRecord::Migration
  def change
    add_column :items, :scale, :integer, default: 0
  end
end
