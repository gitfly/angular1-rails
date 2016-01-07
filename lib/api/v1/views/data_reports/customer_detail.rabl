object :customers => false
node(:customers) do |m|
  @customers.try(:map) do |customer|
    partial("customers/show", object: customer).merge(
      latest_order_time: customer.latest_order.try(:created_at).try(:strftime, "%Y.%m.%d"),
      earliest_order_time: customer.earliest_order.try(:created_at).try(:strftime, "%Y.%m.%d"), 
      customer_source: customer.show_source_of_detail,
      consumption_times: customer.consumption_times, 
      consumption_orders: customer.consumption_orders, 
      consumption_total_money: customer.consumption_total_money, 
      recent_three_months_orders: customer.recent_three_months_orders,
      show_phone: customer.show_phone,
      recent_address: customer.recent_address.try(:show_address),
      show_is_member: customer.show_is_member,
      show_gender: customer.show_gender,
      show_birthday: customer.birthday.try(:strftime, "%Y.%m.%d")
    )
  end
end


node(:old_customers) do |m|
  @old_customers
end

node(:orderd_customers) do |m|
  @orderd_customers
end

node(:new_customers) do |m|
  @new_customers
end

node(:from) do |m|
  @from.strftime("%Y-%m-%d")
end

node(:to) do |m|
  @to.strftime("%Y-%m-%d")
end