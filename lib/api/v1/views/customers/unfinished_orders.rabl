object @customer => false

attributes :id, :name, :weixin

node(:paid_orders) do
  (@orders[true]||[]).map do |o|
    { 
      id: o.id, 
      number: o.number, 
      status: o.show_status_zh, 
      item_info: "#{o.show_color}-#{o.show_brand}-#{o.show_item_type}"
    }
  end
end

node(:unpaid_orders) do
  (@orders[false]||[]).map do |o|
    { 
      id: o.id, 
      number: o.number, 
      status: o.show_status_zh, 
      item_info: "#{o.show_color}-#{o.show_brand}-#{o.show_item_type}"
    }
  end
end

node(:paid_count) do
  @counts[true]
end

node(:unpaid_count) do
  @counts[false]
end
