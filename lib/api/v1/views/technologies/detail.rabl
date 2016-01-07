object @technology => false

attributes :ttype, :order_id, :remark, :end_time, :user_id, :id, 
:show_ttype, :user_name, :show_end_time, :duration, :show_start_time,
:substituted

locals[:object] ||= @technology

if @unqualified
	node(:quality_testing) do |m|
	  partial('quality_testings/brief', object: @unqualified)
	end
end



node(:order) do |m|
  partial('orders/order_for_technology', object: locals[:object].order)
end
