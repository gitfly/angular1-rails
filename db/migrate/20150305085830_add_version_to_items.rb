class AddVersionToItems < ActiveRecord::Migration
  def change
    add_column :items, :version, :string
  end
end
