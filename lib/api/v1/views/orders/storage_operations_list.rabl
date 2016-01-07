object :orders => false

node(:orders) do |m|
  @orders.map do |order|
    partial("orders/storage_operations", object: order)
  end
end