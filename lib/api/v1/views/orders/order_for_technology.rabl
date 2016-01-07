object @order

attributes :id, :number, :customer_id, :diagnose, :rework, :rework_reason, :first_original_photo, 
:first_min_photo, :urgent

locals[:object] ||= @technology

node(:show_sensitivity) do |m|
  locals[:object].customer.show_sensitivity
end

node(:sensitivity) do |m|
  locals[:object].customer.sensitivity
end