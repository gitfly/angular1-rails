object false

node(:type_counts) do
  Order::SearchType.map do |key, v|
    { type: key, count: @orders.send(key).count, name: v }
  end
end

node(:status_counts) do
  {}.tap do |hash|
    @count.each do |key, value|
      hash.merge!(
        I18n.t("order.status.#{OrderStatus::Status.key(key)}") => value
      )
    end
  end
end
