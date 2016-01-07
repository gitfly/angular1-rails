class CreateMaintainParts < ActiveRecord::Migration
  def change
    create_table :maintain_parts do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
