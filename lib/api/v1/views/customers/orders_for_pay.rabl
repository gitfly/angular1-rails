object @customer

attributes :id, :phone, :name, :weixin


node(:orders_count) do |m|
  @orders_count
end

node(:amount) do |m|
  @amount
end

node(:order_ids) do |m|
  @order_ids
end

node(:orders) do |m|
	@orders.map do |order|
	    partial("orders/partial", object: order).merge(
	    	first_original_photo: order.first_original_photo,
	    	first_min_photo: order.first_min_photo
	    )
	end   
end