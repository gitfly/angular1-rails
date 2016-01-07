class AddMaterialCraftVersionSymptomLevelPositionToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :material, :string
    add_column :orders, :craft, :string
    add_column :orders, :version, :string
    add_column :orders, :symptom, :string
    add_column :orders, :level, :string
    add_column :orders, :position, :string
  end
end
