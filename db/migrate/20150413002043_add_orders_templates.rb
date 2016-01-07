class AddOrdersTemplates < ActiveRecord::Migration
  def change
    create_table :orders_solu_templates, id: false do |t|
      t.integer :order_id
      t.integer :solu_template_id
    end
    add_index :orders_solu_templates, [:order_id, :solu_template_id]
  end
end
