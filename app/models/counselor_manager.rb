class CounselorManager < User

  def leftbar_statuses(params)
    Order.filter_by_date_range_or_scope(params).
      filter_order_by_type(params[:type]).
      status_counts(
        :factory_received, 
        :adviser_sorted_out, 
        :diagnosed, 
        :effect_result_created, 
        :effect_result_sent, 
        :effect_result_confirmed
      )
  end

  def leftbar_users(params)
    { 
      type: :handler, 
      text: " 分配到的", 
      keys: Counselor.pluck(:name), 
      values: handler_counts(params),
    }
  end

  def handler_counts(params)
    {}.tap do |hash|
      Counselor.all.map do |counselor|
        hash[counselor.name] = Order.
          joins(:statuses).
          where("order_statuses.forward=1").
          filter_by_zh_status(params[:status]).
          where("order_statuses.status = orders.status").
          group("order_statuses.user_id").
          count[counselor.id]
      end
      hash["所有顾问"] = Order.filter_by_zh_status(params[:status]).count
    end
  end

end
