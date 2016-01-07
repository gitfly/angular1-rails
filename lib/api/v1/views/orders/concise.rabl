object false


node(:orders) do |m|
	@orders.map do |order|
	    partial("orders/partial", object: order).merge(
	      customer_name: order.customer.name,
	      delivery_address: order.delivery_address.try(:show_address),
	      customer_phone: order.customer.phone
	    )
	end   
end

node(:orders_count) do |m|
	@orders_count
end
