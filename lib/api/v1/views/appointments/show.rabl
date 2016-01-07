object @appointment => false

attributes :id, :name, :phone, :show_date, :customer_id, :date,
:finished, :trouble, :trouble_desc, :trouble_type

locals[:object] ||= @appointment

node(:orders) do |m|
  locals[:object].orders.map do |order|
    partial("orders/partial", object: order)
  end
end
