class AddDiscountToRecharge < ActiveRecord::Migration
  def change
    add_column :recharges, :discount, :integer, default: 100
  end
end
