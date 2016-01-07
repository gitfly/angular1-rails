class CreateCompensates < ActiveRecord::Migration
  def change
    create_table :compensates do |t|
      t.integer :ctype
      t.integer :amount
      t.text :reason

      t.timestamps null: false
    end
  end
end
