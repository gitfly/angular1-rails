object false

if @orders
  node(:orders) do |m|
    @orders.map do |order|
      partial("orders/order_for_pay", object: order)
    end
  end

  node(:count) {|m| @orders.count}
end
