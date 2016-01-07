object false

if @quality_testing
  node(:quality_testing) do |m|
    partial('quality_testings/brief', object: @quality_testing)
  end
end

if @order
  node(:order) do |m|
  	partial("orders/order_for_technology", object: @order)
  end
end

if @error_message
  node(:error_message) do |m|
    @error_message
  end
end
if @technology
  node(:technology) do |m|
   partial('technologies/brief', object: @technology) 
  end
end