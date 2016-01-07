object @order => ""

attributes :id, :number, :show_status, :urgent, :color, :show_status, :show_urgent,
:show_pickup_date,:show_delivery_date,:show_item_type, :show_brand, :show_style, 
:show_color, :paid,:show_paid, :fetch_date, :delivery_date, :final_price, :show_remain_money, 
:show_state, :delivery_date_detail, :fetch_date_detail, :pre


node(:fetch_address) do
  partial("addresses/address", object: locals[:object].fetch_address)
end

node(:delivery_address) do
  partial("addresses/address", object: locals[:object].delivery_address)
end
