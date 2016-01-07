class AddColorToItems < ActiveRecord::Migration
  def change
    add_column :items, :color, :string
  end
end
