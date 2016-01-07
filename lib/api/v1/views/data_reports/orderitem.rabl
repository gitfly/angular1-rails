object :orders => false

node(:orders) do |m|
  @orders.map do |order|
    partial("orders/brief", object: order).merge(
      partial("users/show", object: order.customer)
    ).merge(
      price: order.price,
      service: order.show_service, 
      show_brand: order.show_brand,
      final_price: order.final_price, 
      final_discount: order.final_discount,
      show_created_at: order.show_created_at,
      payment_method: order.settlement.try(:pms),
      handler_name: order.settlement.try(:user_name),
      activity_name: order.activity.try(:name) || "无活动", 
      consume_date: order.settlement.try(:created_at).try(:strftime, "%m月%d日 %H:%M:%S")
    )
  end
end

node(:pre_count) do |m|
  @pre_count
end

node(:formal_count) do |m|
  @formal_count
end

node(:total_amounts) do |m|
  @total_amounts
end

node(:pm_amounts_hash) do |m|
  @pm_amounts_hash
end
node(:from) do |m|
  @from.strftime("%Y-%m-%d")
end

node(:to) do |m|
  @to.strftime("%Y-%m-%d")
end

node(:orders_count) do |m|
  @orders_count
end


