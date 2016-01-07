class CreateBadnesses < ActiveRecord::Migration
  def change
    create_table :badnesses do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
