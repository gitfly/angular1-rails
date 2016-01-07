object false

node(:orders) do |m|
  @orders.map do |order|
    partial("orders/order", object: order)
  end
end

node(:count) {|m| @orders.count}
