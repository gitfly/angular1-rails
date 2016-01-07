class AddBeforeToSoluTemplates < ActiveRecord::Migration
  def change
    add_column :solu_templates, :before, :boolean, default: true
  end
end
