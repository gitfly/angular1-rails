class AddGrouponCodesCountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :groupon_codes_count, :integer, default: 0
  end
end
