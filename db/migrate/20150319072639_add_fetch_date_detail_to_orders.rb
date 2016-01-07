class AddFetchDateDetailToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :fetch_date_detail, :string
  end
end
