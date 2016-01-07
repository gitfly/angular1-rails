class AddFetchDataStartAndEnd < ActiveRecord::Migration
  def change
    add_column :orders, :fetch_date_start, :integer
    add_column :orders, :fetch_date_end, :integer
  end
end
