class AddDiscountToCustomer < ActiveRecord::Migration
  def change
    add_column :users, :discount, :float, default: 1.0
  end
end
