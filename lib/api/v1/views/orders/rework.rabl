object @order

attributes :id, :number, :show_item_type, :show_status, :show_status_zh, 
  :customer_id, :show_color, :show_brand, :show_style

@order ||= locals[:object]

node(:technologies) do |m|
  @order.technologies.includes(:quality_testing).map do |tech|
    partial('technologies/show', object: tech)
  end
end
