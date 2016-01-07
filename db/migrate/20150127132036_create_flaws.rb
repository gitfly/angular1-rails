class CreateFlaws < ActiveRecord::Migration
  def change
    create_table :flaws do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
