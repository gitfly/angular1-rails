class AddBuyDateAndSourceToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :buy_date, :date
    add_column :orders, :source, :string
  end
end
