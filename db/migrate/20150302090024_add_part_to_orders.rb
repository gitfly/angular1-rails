class AddPartToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :part, :string
  end
end
