object false

if @orders
  node(:count) {|m| @orders.count}
  node(:order_list) do |m|
    @orders.map do |order|
      partial("orders/order_for_pay", object: order)
    end
  end
end

if @customer
  node(:customer) do |m|
    partial("customers/show", object: @customer)
  end
end


if @activity
  node(:activity) do |m|
    partial("activities/show", object: @activity)
  end
end
