object false

node(:customers) do |m|
  @customers.map do |customer|
    partial("customers/show", object: customer).merge(
      referrer: partial("friends/show", object: customer.referrer)
    ).merge(
      orders: customer.orders.uncompleted.map do |order|
        partial("orders/brief", object: order)
      end
    ).merge(
      order_summary: customer.orders.uncompleted.inject(Hash.new(0)) do |h, e| 
        h[e.show_item_type] += 1 ; h
      end.map do |k, v|
        "#{v}个#{k}"
      end.join(',')
    )
  end
end


# object @customers
# attributes :id, :email, :phone, :avatar_url

# node(:orders) do |m|
#   @orders.map do |order|
#     partial("orders/order", object: order).merge(
#       partial("users/show", object: order.customer)
#     ).merge(
#       partial('items/show', object: order.item)
#     )
#   end
# end
# node(:count) {|m| @count}
object :customers
