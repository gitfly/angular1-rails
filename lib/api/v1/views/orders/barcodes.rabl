object false

node(:barcodes) do |m|
  @barcodes.map do |barcode|
    partial("orders/barcode", object: barcode)
  end
end
