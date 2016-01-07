object false

@orders ||= locals[:object]

node(:count) {|m| @orders.count}
node(:order_list) do |m|
  @orders.map do |order|
    partial("orders/type_order", object: order)
  end
end
if @customer
  node(:customer) do |m|
    partial("customers/brief", object: @customer).merge(
      recharge_total: @customer.recharge_total
    )
  end
end
