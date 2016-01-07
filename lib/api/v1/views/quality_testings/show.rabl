object @quality_testing => false

attributes :id, :technology_id, :tester_id, :qualified, :remark, :refer

locals[:object] ||= @quality_testing
if @quality_testing
  node(:photo) do |m|
    partial('photos/photo', object: locals[:object].photo) 
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