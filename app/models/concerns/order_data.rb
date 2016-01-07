module OrderData
  extend ActiveSupport::Concern

  included do
    scope :disabled, -> { where(disabled: true) }
  end

  class_methods do
    def packaging_date(params)
      if params[:from].blank?
        from = Time.zone.now.beginning_of_day - 7.days
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

    def packaging_group_param(params, table_name)
      from, to = packaging_date(params)
      date_zh = "%Y-%m-%d"
      time_array = (from.to_s.to_date..to.to_s.to_date).map{ |date| date.strftime("%Y-%m-%d") }
      from = from.to_date
      to = to.to_date
      if (to-from) > 31 && (to-from) < 180 
        time_array = (from..to).map{ |date| date.strftime("第%W周") }.uniq
        date_zh="第%U周"
      elsif (to-from) >= 180
        time_array = (from..to).map{ |date| date.strftime("%Y年%m月") }.uniq
        date_zh="%Y年%m月"
      end
      group_param = "DATE_FORMAT(#{table_name}.created_at, '#{date_zh}') as created_date"
      customer_group_param = "DATE_FORMAT(MIN(#{table_name}.created_at), '#{date_zh}') as created_date"
      return [group_param, customer_group_param, time_array]
    end

    def convert_illegal_num(num)
      if num.nan?
        num = 0
      end
      return  num 
    end

    def get_report_home_datas(params)
      from, to = packaging_date(params)
      group_param, customer_group_param, time_array = packaging_group_param(params, "orders")
      paid_group_param = packaging_group_param(params, "settlements")[0]
      paid_select_param = "count(distinct(settlements.customer_id)) as paid_customer_total_count," \
                          "count(orders.id) as paid_order_total_count, " \
                          "#{paid_group_param}"
                          
      select_param = "count(distinct(customer_id)) as customer_total_count,"\
                     "count(id) as order_total_count,"\
                     "sum(final_price)/100.00 as gmv, "\
                     "count(1) as new_customer, "\
                     "count(1) as paid_customer_total_count, "\
                     "count(1) as paid_order_total_count ,"\
                     "count(1) as paid_total, "\
                     "count(1) as pre_orders_count, "\
                     "count(1) as pre_customers_count, "\
                     "#{group_param}"

      arrs = Order.select("#{customer_group_param}, 1 as num").where("cancel=0").group("customer_id").order("created_date DESC")
      maps = arrs.group_by{|o| o.created_date}

      paid_orders = Order.select(
        paid_select_param
      ).joins(:settlement)
      .where(cancel: false)
      .where(pre: false)
      .where(
        :orders => {:settlement_id => Settlement.filter_by_date(from, to).ids}
      ).group("created_date").order("created_date DESC")

      daily_amounts = Settlement.select(
        "#{paid_group_param},sum(amount)/100.0 as paid_total"
      ).filter_by_date(from, to)
      .group("created_date")
      .order("created_date DESC")

      pre_orders = Order.select(
        "#{group_param},count(id) as pre_orders_count, count(distinct(customer_id)) as pre_customers_count"
      ).filter_by_date(from, to)
      .where(pre: true)
      .group("created_date")
      .order("created_date DESC")

      orders = Order.select(select_param)
      .where(cancel: false).filter_by_date(from, to)
      .where(pre: false)
      .group("created_date")
      .order("created_date DESC")

      orders_hash = Hash[orders.map { |order| [order.created_date, order] }]
      paid_orders_hash = Hash[paid_orders.map { |order| [order.created_date, order] }]
      daily_amounts_hash = Hash[daily_amounts.map { |amount| [amount.created_date, amount] }]
      pre_orders_hash = Hash[pre_orders.map { |order| [order.created_date, order] }]
      order_array = []
      time_array.reverse.each do |date|
        order = orders.first.dup
        order.created_date = date
        order.customer_total_count = 0
        order.order_total_count = 0
        order.gmv = 0
        order.paid_customer_total_count = 0
        order.paid_order_total_count = 0
        order.paid_total = 0
        order.pre_orders_count = 0
        order.pre_customers_count = 0
        paid_order = paid_orders_hash[date]
        daily_amount = daily_amounts_hash[date]
        pre_orders = pre_orders_hash[date]
        order_obj = orders_hash[date]        
        num = maps[date].try(:size)
        num = 0 unless num
        order.new_customer = num
        if paid_order
          order.paid_customer_total_count = paid_order.paid_customer_total_count
          order.paid_order_total_count = paid_order.paid_order_total_count          
        end

        if daily_amount
          order.paid_total = daily_amount.paid_total
        end

        if pre_orders
          order.pre_orders_count = pre_orders.pre_orders_count
          order.pre_customers_count = pre_orders.pre_customers_count
        end

        if order_obj
          order.customer_total_count = order_obj.customer_total_count
          order.order_total_count = order_obj.order_total_count
          order.gmv = order_obj.gmv
        end
        order_array << order
      end
      return order_array

    end

    def packaging_data(params={})
      orders = get_report_home_datas(params)
      results = []
      user_count = []
      order_count = []
      order_count_per_user = []
      gmv = [] 
      gmv_order_price = []
      gmv_user_price = []
      paid_order_count = []
      paid_user_count = []
      paid_money = []
      paid_order_price = []
      paid_user_price = []
      new_customer = []
      pre_orders_count = []
      pre_customers_count = []
      titles = ["","均值","总计"]
      orders.each do |order|
        titles << order.created_date
        user_count << order.customer_total_count
        order_count << order.order_total_count
        order_count_per_user << convert_illegal_num((order.order_total_count.to_f/order.customer_total_count.to_f).round(2))
        gmv << order.gmv
        gmv_user_price << convert_illegal_num((order.gmv.to_f/order.customer_total_count.to_f).round(2)) 
        gmv_order_price <<convert_illegal_num((order.gmv.to_f/order.order_total_count.to_f).round(2))
        paid_order_count << order.paid_order_total_count
        paid_user_count << order.paid_customer_total_count
        paid_money << order.paid_total
        paid_order_price << convert_illegal_num((order.paid_total.to_f/order.paid_order_total_count.to_f).round(2))
        paid_user_price << convert_illegal_num((order.paid_total.to_f/order.paid_customer_total_count.to_f).round(2))
        new_customer << order.new_customer
        pre_orders_count << order.pre_orders_count
        pre_customers_count << order.pre_customers_count
      end

      results << titles
      results << sum_avg_arr(user_count).unshift("用户量")
      results << sum_avg_arr(order_count).unshift("订单量")
      results << sum_avg_arr(order_count_per_user).unshift("人均下单量")
      results << sum_avg_arr(gmv).unshift("日流水")
      results << sum_avg_arr(gmv_order_price).unshift("订单单价")
      results << sum_avg_arr(gmv_user_price).unshift("客单流水")
      results << sum_avg_arr(paid_order_count).unshift("支付订单量")
      results << sum_avg_arr(paid_user_count).unshift("支付用户量")
      results << sum_avg_arr(paid_money).unshift("支付金额")
      results << sum_avg_arr(paid_order_price).unshift("支付订单单价")
      results << sum_avg_arr(paid_user_price).unshift("支付客单价")
      results << sum_avg_arr(new_customer).unshift("新用户数")
      results << sum_avg_arr(pre_customers_count).unshift("预订单用户量")
      results << sum_avg_arr(pre_orders_count).unshift("预订单量")
      return results
   
    end


    def sum_avg_arr(arr) 
      avg = (arr.sum.to_f/arr.size).round(2)
      total = arr.sum.round(2)
      arr.unshift(total) 
      arr.unshift(avg) 
      return arr
    end

    def export_data(params)
      results = packaging_data(params)
      titles = results.shift
      p = Axlsx::Package.new
      p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
        sheet.add_row titles
       results.each do |order|  
          sheet.add_row(order)          
        end
      end and nil
      # p.use_shared_strings = true
      p.serialize("tmp/report_home.xlsx")
    end
  end

end
