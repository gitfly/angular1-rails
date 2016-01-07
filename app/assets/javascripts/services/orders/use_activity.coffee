app = window.app

app.factory 'useActivity', (Activity, Orders) ->
  (orders, activity) ->
    
    calculate_price = (order, price) ->
      if parseInt(activity.discountManner) == 0
        order.showActivityName = "#{activity.name}(打#{activity.amount}折)"
        order.showActivityInfo = (price * activity.amount)/100.0
      else
        order.showActivityName = "#{activity.name}(直接减免#{activity.amount})"
        order.showActivityInfo = price - activity.amount

    _.each(orders.selected(), (order) ->
      memberPrice = order.price * order.discount

      unless activity
        order.finalPrice = memberPrice
        order.showActivityName = "无活动"
        order.showActivityInfo = ""
      else
        if activity.atype == 10
          calculate_price(order, order.price)
        else if activity.atype == 0
          price = if activity.addup then memberPrice else order.price
          calculate_price(order, price)
        else if activity.atype == 3
          order.showActivityName = "#{activity.name}(全部#{activity.amount}元)"
          order.showActivityInfo = activity.amount
        else if activity.atype == 1
          order.showActivityName =
            "#{activity.name}(#{activity.amount}抵#{activity.originalPrice})"
          codeCount = activity.activityCodes.length
          p = order.price - activity.originalPrice * codeCount
          order.showActivityInfo = "使用#{codeCount}张券：#{p}"

        if order.showActivityInfo > memberPrice
          order.finalPrice = memberPrice
        else
          order.finalPrice = order.showActivityInfo
    )
    return true
