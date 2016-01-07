object false

node(:customers) do |m|
  @customers.map do |customer|
    partial("customers/info", object: customer).merge(
      orders: customer.orders.map do |order|
        partial("orders/order_for_fetch_delivery", object: order)
      end
    ).merge(
      money: customer.orders.map do |o|
        o.show_remain_money
      end.sum.round(2)
    )
  end
end

node(:from) do |m|
  @from
end

node(:items_num) do |m|
  @items
end

node(:customers_num) do |m|
  @customer_ids.size
end

object :customers
