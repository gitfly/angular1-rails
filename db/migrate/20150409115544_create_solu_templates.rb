class CreateSoluTemplates < ActiveRecord::Migration
  def change
    create_table :solu_templates do |t|
      t.text :header
      t.text :footer

      t.timestamps null: false
    end
  end
end
