object @activity

attributes :id, :name, :item_type, :discount_manner, 
  :amount, :content, :start_date, :end_date, 
  :addup, :show_coupon, :show_addup, :show_item_type, 
  :consume_add_up, :show_atype, :atype

if @orders
  node(:orders) do |m|
    @orders.map do |order|
      partial("orders/order_for_pay", object: order)
    end
  end
end
