object @order

attributes :id, :number, :fetch_date, :delivery_date, :show_status, :urgent, :color, :status, 
  :show_pickup_manner, :show_delivery_manner, :pickup_manner, :delivery_manner, :request, 
  :show_urgent, :show_created_at, :finish_date, :attachment, :part, :gift, :buy_date, :source, 
  :show_pickup_date, :show_delivery_date, :show_service, :price, :discount, :real_price, 
  :show_paid, :material, :position, :level, :symptom, :craft, :next_status, :last_status, 
  :show_status_zh, :show_item_type, :show_brand, :show_style, :show_color, :paid, :final_price, 
  :barcode_url, :thumb_barcode_url, :show_service_ids, :service_ids, :start_work_date, 
  :show_attachment, :show_part, :cancel_reason, :show_type, :act_price, :cancel, 
  :customer_id, :discount_price, :final_discount, :refunded, :compensated, :cancel_refund, :refund, 
  :compensate, :groupon_codes_count, :fetch_hour_start, :fetch_hour_end, :delivery_hour_start, 
  :delivery_hour_end, :service_name, :pre, :diagnose, :rework, :late, :rework_reason, :completed, :show_pms


locals[:object] ||= @order

node(:activity) do
  partial('activities/show', object: locals[:object].activity)
end

node(:friend) do |customer|
  partial("friends/show", object: locals[:object].friend)
end

node(:customer) do |customer|
  partial("customers/show", object: locals[:object].customer)
end

node(:item) do |customer|
  partial("items/show", object: locals[:object].item)
end

node(:fetch_address) do |customer|
  partial("addresses/address", object: locals[:object].fetch_address)
end

node(:delivery_address) do |customer|
  partial("addresses/address", object: locals[:object].delivery_address)
end

node(:services) do |customer|
  partial("services/show", object: locals[:object].services)
end
if @error_message 
  node(:error_message) do |m|
    @error_message
  end
end
