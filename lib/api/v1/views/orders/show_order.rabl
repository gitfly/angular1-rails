object @order

attributes :id, :number, :fetch_date, :delivery_date, :urgent, :show_pickup_manner, :show_delivery_manner, :pickup_manner, :delivery_manner, :request, :show_urgent, :show_created_at, :finish_date, :attachment, :part, :gift, :buy_date, :source, :show_pickup_date, :show_delivery_date, :price, :discount, :show_paid, :show_item_type, :show_brand, :show_style, :show_color, :paid, :final_price, :start_work_date, :cancel_reason, :show_type, :act_price, :cancel, :pre, :diagnose, :rework, :late, :rework_reason, :act_price, :member_price, :show_status_zh, :customer_id, :show_status, :show_next_status, :show_next_status_zh, :service_name, :show_pickup_manner, :pickup_manner, :delivery_manner, :show_delivery_manner, :fetch_hour_start, :fetch_hour_end, :friend, :delivery_date_details, :delivery_hour_start, :delivery_hour_end

@order ||= locals[:object]

node(:customer) do |customer|
  partial("customers/brief", object: @order.customer)
end

node(:item) do
  partial("items/show", object: @order.item)
end

if @order.activity_id
  node(:activity) do |activity|
    { name: @order.activity.try(:name), show_coupon: @order.activity.try(:show_coupon) }
  end
end

if @log
  node(:logs) do
    partial("order_logs/index", object: @order.logs.includes(:user).order('id desc'))
  end
end

node(:fetch_address) do |customer|
  partial("addresses/address", object: @order.fetch_address)
end

node(:delivery_address) do |customer|
  partial("addresses/address", object: @order.delivery_address)
end
