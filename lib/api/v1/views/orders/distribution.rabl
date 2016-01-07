object false

node(:orders) do |m|
	@os.map do |o|
	    partial("orders/partial", object: o.order).merge(
	       user_name: o.user.name
	    )
	end   
end


node(:orders_count) do |m|
	@orders_count
end




