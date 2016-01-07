class ChangeItemIdFromOrder < ActiveRecord::Migration
  def change
    change_column :orders, :item_id, :integer, :null => true
  end
end
