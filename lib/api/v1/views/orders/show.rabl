object @order

attributes :id, :number, :fetch_date, :delivery_date, :show_status, :urgent, :color, :status, :show_pickup_manner, :show_delivery_manner, :pickup_manner, :delivery_manner, :request, :show_urgent, :show_created_at, :finish_date, :attachment, :part, :gift, :buy_date, :source, :show_pickup_date, :show_delivery_date, :show_service, :price, :discount, :real_price, :show_paid, :material, :position, :level, :symptom, :craft, :next_status, :last_status, :show_status_zh, :show_item_type, :show_brand, :show_style, :show_color, :paid, :final_price, :barcode_url, :thumb_barcode_url, :show_service_ids, :service_ids, :start_work_date, :show_attachment, :show_part, :barcode_html, :cancel_reason, :show_type, :act_price, :cancel, :pre, :diagnose, :rework, :late, :rework_reason, :completed?

@order ||= locals[:object]

node(:customer) do |customer|
  partial("customers/show", object: @order.customer)
end

node(:item) do |customer|
  partial("items/show", object: @order.item)
end

node(:fetch_address) do |customer|
  partial("addresses/address", object: @order.fetch_address)
end

node(:delivery_address) do |customer|
  partial("addresses/address", object: @order.delivery_address)
end

node(:friend) do |customer|
  partial("friends/show", object: @order.friend)
end

node(:before_template) do |m|
  partial("solu_templates/show", object: @order.before_template)
end

node(:after_template) do |m|
  partial("solu_templates/show", object: @order.after_template)
end

node(:item_parts) do |m|
  @order.item_parts.map do |category|
    partial('categories/show', object: category)
  end
end

node(:technologies) do |m|
  @order.technologies.includes(:quality_testings).map do |tech|
    partial('technologies/show', object: tech)
  end
end
