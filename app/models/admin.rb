class Admin < User
  def leftbar_types(params)
    Order.filter_by_date_range_or_scope(params).search_type_counts
  end

  def leftbar_statuses(params)
    Order.filter_by_date_range_or_scope(params).
      filter_order_by_type(params[:type]).status_counts
  end
end
