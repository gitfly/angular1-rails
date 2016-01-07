class ChangeColomnsInOrders < ActiveRecord::Migration
  def change
    add_column :orders, :maintain_part, :string, default: ''
    add_column :orders, :flaw, :string, default: ''
    add_column :orders, :badness, :string, default: ''
  end
end
