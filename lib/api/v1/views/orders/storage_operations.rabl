object @order

attributes :id, :number, :show_item_type, :attachment, :show_status, :show_status_zh, :part,
  :customer_id, :show_color, :show_brand, :show_style, :price, :discount, :gift, :show_pickup_manner,
  :show_attachment, :show_part, :show_delivery_manner, :pickup_manner, :delivery_manner, :status

@order ||= locals[:object]

node(:customer) do |customer|
 partial("customers/brief", object: @order.customer)
end

node(:proportion) do
 "#{@order.customer.all_orders_count(@next_status)}/#{@order.customer.all_orders_count(nil)}"
end

