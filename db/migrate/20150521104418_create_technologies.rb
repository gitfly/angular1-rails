class CreateTechnologies < ActiveRecord::Migration
  def change
    create_table :technologies do |t|
      t.integer :ttype
      t.integer :order_id
      t.text :remark
      t.datetime :end_time
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :technologies, :order_id
    add_index :technologies, :user_id
  end
end
