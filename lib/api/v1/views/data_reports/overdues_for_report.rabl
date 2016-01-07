object :overdues => false

node(:overdues) do |m|
  @overdues.map do |overdue|
    partial("overdues/overdue", object: overdue).merge(
    	order_number: overdue.order.number,
    	customer_name: overdue.order.customer.name,
    	item_type: overdue.order.show_item_type,
    	order_created_at: overdue.order.try(:created_at).try(:strftime, "%Y-%m-%d"),
    	overdue_times: overdue.order.show_overdue_times
    )
  end
end

node(:from) do |m|
  @from.try(:strftime, "%Y-%m-%d")
end

node(:should_finished) do |m|
  @should_finished_orders.length
end


