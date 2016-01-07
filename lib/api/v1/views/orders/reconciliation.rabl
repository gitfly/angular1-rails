object :orders => false

node(:orders) do |m|
  @orders.map do |order|
    partial("orders/brief", object: order).merge(
      partial("users/show", object: order.customer)
    ).merge(
      payment_method: order.settlement.try(:pms),
      activity_name: order.activity.try(:name) || "无活动", 
      service: order.show_service, 
      final_price: order.final_price, 
      price: order.price,
      consume_date: order.settlement.try(:created_at).try(:strftime, "%m月%d日 %H:%M:%S")
    )
  end
end

node(:count) do |m|
  @count
end

node(:total) do |m|
  @total
end
