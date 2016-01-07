object false

if @order
	node(:order) do |m|
	    partial("orders/partial", object: @order).merge(
	      customer_name: @order.customer.name,
	      delivery_address: @order.delivery_address.try(:show_address),
	      customer_phone: @order.customer.phone
	    )
	end
end

if @error_message
	node(:error_message) do |m|
       @error_message
    end
end

if @order_count
	node(:order_count) do |m|
	   @order_count
	end
end


