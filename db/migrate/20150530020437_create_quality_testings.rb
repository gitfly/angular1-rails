class CreateQualityTestings < ActiveRecord::Migration
  def change
    create_table :quality_testings do |t|
      t.integer :technology_id
      t.integer :tester_id 
      t.boolean :qualified, default: false
      t.text :remark

      t.timestamps null: false
    end
    add_index :quality_testings, :technology_id
    add_index :quality_testings, :tester_id
  end
end
