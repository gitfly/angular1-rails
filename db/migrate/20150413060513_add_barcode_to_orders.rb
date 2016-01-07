class AddBarcodeToOrders < ActiveRecord::Migration
  def change
    add_attachment :orders, :barcode
  end
end
