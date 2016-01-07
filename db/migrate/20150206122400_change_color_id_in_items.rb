class ChangeColorIdInItems < ActiveRecord::Migration
  def change
    remove_column :items, :color_id
    add_column :items, :color_id, :integer
  end
end
