class CreateBarcodes < ActiveRecord::Migration
  def change
    create_table :barcodes do |t|
      t.string :number
      t.attachment :barcode

      t.timestamps null: false
    end
    add_index :barcodes, :number
  end
end
