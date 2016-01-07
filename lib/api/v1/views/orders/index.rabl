object :orders

node(:orders) do |m|
  @paged_orders.map do |order|
    partial("orders/order_for_index", object: order).merge(
      name: order.customer.try(:name),
      weixin: order.customer.try(:weixin)
    )
  end
end

# node(:extras) do
#   [
#     {
#       "操作人": @orders.joins(:statuses => :user).where("order_statuses.status = orders.status").select('users.name as handler').map(&:handler)
#     }
#   ]
# end

node(:count) {|m| @searched_count}
