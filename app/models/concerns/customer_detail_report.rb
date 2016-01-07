module CustomerDetailReport
  extend ActiveSupport::Concern

  module ClassMethods
    def parse_param_date(params, past_days=0)
      if params[:from].blank?
        from = Time.zone.now.beginning_of_day - past_days.days
      else 
        from = Time.parse(params[:from]).beginning_of_day
      end

      if params[:from].blank?
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

    def getCustomerDetails(params)
      from, to = convert_date(params)
      customers = Customer.eager_load(:orders).where(
        "orders.created_at > '#{from}' and orders.created_at < '#{to}' and orders.cancel=0"
      ).group(users: :id).order("max(orders.created_at) desc")
      unless params[:is_member].blank?
        customers = customers.where("users.is_member = #{params[:is_member]}")
      end

      unless params[:customer_source].blank?
        customers = customers.where("users.source = #{params[:customer_source]}")
      end

      unless params[:total_order_num].blank?
        having_cond = "count(id) = #{params[:total_order_num]}"
        customers = customers.where(
          :id => Order.select(:customer_id).where(cancel: false).group(:customer_id).having(having_cond)
        )
      end

      unless params[:recent_order_num].blank?
        recent = (Time.now - 90.days).beginning_of_day
        now = Time.now
        cond = "orders.created_at > '#{recent}' and "\
                      "orders.created_at <= '#{now}' and "\
                      "cancel=0"
        having_cond = "count(orders.id) = #{params[:recent_order_num]}"
        customers = customers.where(
          :id => Order.select(:customer_id).where(cond).group(:customer_id).having(having_cond)
        )
      end

      unless params[:total_consume_num].blank?
        having_cond = "count(distinct(date(orders.created_at))) = #{params[:total_consume_num]}"
        customers = customers.where(
          :id => Order.select(:customer_id).where(cancel: false).group(:customer_id).having(having_cond)
        )
      end
      return [customers,from, to]
     
    end

    # def get_customer_nums_by_order_count(params, order_count)
    #   from, to = convert_date(params)
    #   customers = Order.filter_by_date(from, to).where(cancel: false).group("customer_id").having("count(id) #{order_count}")
    #   return customers
    # end

    # def get_orderd_customer_nums(params)
    #   from, to = convert_date(params)
    #   customers_num = Order.filter_by_date(from, to).where(cancel: false).count("distinct(customer_id)")
    #   return customers_num
    # end



    def exportCustomerDetails(params)
      @customers = getCustomerDetails(params)[0]
      @new_customers = @old_customers = 0
      @customers.each do |customer| 
        if customer.consumption_times == 1
          @new_customers += 1 
        elsif customer.consumption_times > 1
          @old_customers += 1
        end
      end
      @orderd_customers = @customers.length
        first_row = [
          "新增用户数:#{@new_customers}",           
          "老用户数:#{@old_customers}",       
          "总下单用户数:#{@orderd_customers}", 
          "重复购买率:#{(@old_customers.to_f/@orderd_customers.to_f)*100.round(2)}%"
        ]
      
        titles = %W(最近消费日期 用户名 手机号 微信号 是否会员 性别 生日 职业 用户来源 首次消费日期 总消费次数 总消费订单量 总消费金额 订单单价 包单价 最近三个月消费订单量 最近收货地址)
      
      p = Axlsx::Package.new
      p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
        sheet.add_row first_row
        sheet.add_row []
        sheet.add_row []
        sheet.add_row []
        sheet.add_row titles
        @customers.each do |customer|  
          sheet.add_row([].tap do |arr|            
            arr << customer.latest_order.try(:created_at).try(:strftime, "%Y-%m-%d %H:%M:%S")
            arr << customer.name            
            arr << customer.phone
            arr << customer.weixin
            arr << customer.show_is_member            
            arr << customer.show_gender      
            arr << customer.birthday.try(:strftime, "%Y-%m-%d %H:%M:%S")
            arr << customer.job
            arr << customer.show_source_of_detail
            arr << customer.earliest_order.try(:created_at).try(:strftime, "%Y-%m-%d %H:%M:%S")
            arr << customer.consumption_times
            arr << customer.consumption_orders
            arr << customer.consumption_total_money
            arr << (customer.consumption_total_money/customer.consumption_times).round(2)
            arr << (customer.consumption_total_money/customer.consumption_orders).round(2)
            arr << customer.recent_three_months_orders
            arr << customer.recent_address.try(:show_address)
          end)        
        end
      end and nil
      p.use_shared_strings = true
      p.serialize("tmp/customer_detail.xlsx")

    end
    
  end

end