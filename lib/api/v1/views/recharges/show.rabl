object @recharge

attributes :id, :amount, :bonus, :customer_id, :content, :pm, :user_id, :discount

node(:customer) do |c|
  partial("customers/brief", object: @customer)
end

node(:orders) do |m|
  @orders.map do |order|
    partial("orders/type_order", object: order)
  end
end

