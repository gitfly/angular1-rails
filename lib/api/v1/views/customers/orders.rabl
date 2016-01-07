object @customer => false

attributes :id, :name, :weixin

node(:orders) do
  @orders.map do |o|
    { id: o.id,  number: o.number, item_type: o.show_item_type, final_price:o.final_price}
  end
end

node(:counts) do
  @counts
end if params[:with_counts] == 'true'
