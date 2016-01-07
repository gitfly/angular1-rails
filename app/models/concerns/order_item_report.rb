module OrderItemReport
  extend ActiveSupport::Concern

  included do
    scope :disabled, -> { where(disabled: true) }
  end

  class_methods do
    def eager_load_all
      self.eager_load(:item, :customer, :activity, :refunds)
    end

    def parse_param_date(params)
      if params[:from].blank?
        from = Time.zone.now.beginning_of_day
      else
        from = Time.parse(params[:from]).beginning_of_day
      end

      if params[:to].blank?
        to = Time.zone.now
      else
        to = Time.parse(params[:to]).end_of_day
      end
      return [from, to]

    end

    def convert_date(params)
      to = Time.zone.now
      case params[:from]
      when 'today'
        from = Time.zone.now.beginning_of_day
      when 'week'
        from = Time.zone.now.beginning_of_week
      when 'month'
        from = Time.zone.now.beginning_of_month
      else
        from, to = parse_param_date(params)
      end
      return [from, to]
    end

    def getOrderItem(params, for_payment)
      from, to = convert_date(params)
      if for_payment
        orders = Order.eager_load(:settlement).paid.where("settlements.created_at > '#{from}'")
        orders = orders.where("settlements.created_at <= '#{to}'").order("settlements.created_at desc")
      else
        orders = Order.eager_load(:settlement).filter_by_date(from, to).order(created_at: :desc)
      end

      orders = orders.eager_load_all.where(
        customer: {is_member: params[:is_member]}
      ) unless params[:is_member].blank?

      orders = orders.eager_load_all.where(
        item: {type: params[:item_type]}
      ) unless params[:item_type].blank?

      orders = orders.eager_load_all.where(
        activity: {id: params[:activity_id]}
      ) unless params[:activity_id].blank?

      return [orders, from, to]
    end

    def getIncomeDetial(orders)
      ids = orders.map do |o|
        o.settlement_id
      end
      pm_amounts = PayRecord.where(settlement_id:  ids).group(:pm).sum(:amount)
      total_amounts = Settlement.where(id: ids).sum(:amount)/100.00
      pm_amounts_per_method = {}
      pm_amounts.each do |k,v|
        key = ConsumptionRecord::PaymentMethod.key k
        v = v/100.00 unless v==0.00
        pm_amounts_per_method[key] = v
      end
      return [total_amounts, pm_amounts_per_method]
    end


    def exportOrderItem(params, for_payment)
      orders = getOrderItem(params, for_payment)[0]
      total_amounts, pm_amounts_per_method = getIncomeDetial(orders)
      if for_payment
        titles = %W(结账时间 订单编号 物品类型 服务类型 顾客姓名 原价 活动名称 结算金额 折扣额度 结算方式 开单日期)
        first_row = [
          "总收入:#{total_amounts} 元",
          "现金:#{pm_amounts_per_method[:现金] || 0} 元",
          "会员卡:#{pm_amounts_per_method[:会员卡] || 0} 元",
          "刷卡:#{pm_amounts_per_method[:刷卡] || 0} 元",
          "微信:#{pm_amounts_per_method[:微信支付] || 0} 元",
          "支付宝:#{pm_amounts_per_method[:支付宝支付] || 0} 元",
          "转账:#{pm_amounts_per_method[:银行转账] || 0} 元",
          "会员代付:#{pm_amounts_per_method[:使用朋友会员卡消费] || 0} 元"
        ]
      else
        titles = %W(开单日期 订单编号 物品类型 服务类型 品牌 顾客姓名 订单状态 原价 活动名称 结算金额 折扣额度 结算方式 结账时间)
        first_row = [
          "总订单:#{orders.count} 单",
          "预订单:#{orders.where(pre: true).count} 单",
          "已开单:#{orders.where(pre: false).count} 单"
        ]

      end

      p = Axlsx::Package.new
      p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
        sheet.add_row first_row
        sheet.add_row []
        sheet.add_row []
        sheet.add_row []
        sheet.add_row []
        sheet.add_row titles
        orders.each do |order|
          sheet.add_row([].tap do |arr|
            if for_payment
              arr << order.settlement.try(:created_at).try(:strftime, "%m月%d日 %H:%M:%S")
            else
              arr << order.show_created_at
            end
            arr << " #{order.number} "
            arr << order.show_item_type
            arr << order.show_service
            unless for_payment
              arr << order.show_brand
            end
            arr << order.customer.name
            unless for_payment
              arr << order.show_status_zh
            end
            arr << order.price
            arr << order.activity.try(:name) || "无活动"
            arr << order.final_price
            arr << order.final_discount
            arr << order.settlement.try(:pms)
            if for_payment
              arr << order.show_created_at
            else
              arr << order.settlement.try(:created_at).try(:strftime, "%m月%d日 %H:%M:%S")
            end
          end)
        end
      end and nil
      # p.use_shared_strings = true
      p.serialize("tmp/report_export.xlsx")

    end
  end

end
