object @order => ""

attributes :id, :number, :fetch_date, :delivery_date, :show_status, :urgent, :color, :status, :show_pickup_manner, :show_delivery_manner, :pickup_manner, :delivery_manner, :request, :show_urgent, :show_created_at, :finish_date, :attachment, :part, :gift, :buy_date, :source, :show_pickup_date, :show_delivery_date, :show_service, :price, :discount, :real_price, :show_paid, :material, :position, :level, :symptom, :craft, :next_status, :last_status, :show_status_zh, :show_item_type, :show_brand, :show_style, :show_color, :paid, :final_price, :barcode_url, :thumb_barcode_url, :show_service_ids, :service_ids, :start_work_date, :show_attachment, :show_part, :barcode_html, :cancel_reason, :show_type, :cancel, :act_price, :pre, :diagnose, :rework, :late, :rework_reason, :show_overdues, :completed?

node(:fetch_address) do
  partial("addresses/address", object: locals[:object].fetch_address)
end

node(:delivery_address) do
  partial("addresses/address", object: locals[:object].delivery_address)
end

node(:activity) do
  partial("activities/show", object: locals[:object].activity)
end
