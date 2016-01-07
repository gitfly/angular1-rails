object :abnormal_orders => false
node(:abnormal_orders) do |m|
  @abnormal_orders.try(:map) do |order|
    partial("orders/brief", object: order).merge(
      abnormal_time: order.abnormal_info.try(:created_at).try(:strftime, "%Y-%m-%d"),
      abnormal_info: order.abnormal_info.try(:changed_values)
    )
  end
end

node(:advance_order_count) do |m|
  @advance_order.count
end

node(:send_to_factory_count) do |m|
  @send_to_factory.count
end

node(:factory_receive_count) do |m|
  @factory_receive.count
end

node(:out_of_storage_count) do |m|
  @out_of_storage.count
end

node(:store_receive_count) do |m|
  @store_receive.count
end

node(:complete_count) do |m|
  @complete.count
end