class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name, default: ''

      t.timestamps null: false
    end
  end
end
