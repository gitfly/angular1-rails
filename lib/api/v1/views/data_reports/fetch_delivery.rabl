object :orders => false

node(:items) do |m|
  @items.map do |obj|
    partial("orders/order_for_fetch_delivery", object: obj[0]).merge(
    	item_detail: obj[1],
      money: obj[2]
    )
  end
end

node(:from) do |m|
  @from	
end


