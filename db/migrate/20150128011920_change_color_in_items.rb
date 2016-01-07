class ChangeColorInItems < ActiveRecord::Migration
  def change
    remove_column :items, :color
    add_column :items, :color_id, :integer, null: false
    add_index :items, :color_id
  end
end
