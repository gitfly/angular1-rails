class API::V1::Orders < Grape::API
  include API::V1::Helpers
  # include Grape::Kaminari

  doorkeeper_for :all

  before do
    # authorize!(@action, @object)
  end

  helpers do
  end

  resource :orders do

    get '/free_numbers_barcodes', rabl: 'orders/barcodes' do
      count = params[:count].to_i
      @barcodes = Barcode.generate_barcodes(count)
    end

    desc "get order blue print templates"
    get '/:id/template', rabl: "solu_templates/show" do
      @order = Order.find(params[:id])
      @template = @order.send("#{params[:type]}_template")
    end

    desc "get photos of an order"
    get "/:id/photos", rabl: "orders/photos" do
      @order = Order.find(params[:id])
      @photos = @order.photos.before.send(params[:scope]||:all)
      @with_child = params[:with_child] == 'true'
      @photos = @photos.includes(:after) if @with_child
    end

    desc "get orders by status for IOS"
    get '/status', rabl: 'orders/concise' do     
      @orders = Order.joins(:customer).includes(:photos,:customer,:photos).where(
        status: ::OrderStatus::Status[params[:status].to_sym]
      )
      if ["order_created", "store_acknowledge_receipt"].include? params[:status] 
        @orders = @orders.where(pickup_manner: ::Order::PickupManner[:包拯上门取])
      end

      if "adviser_sorted_out" == params[:status]
        @orders = @orders.joins(:statuses).where(
          :statuses => {
            user_id: current_user.id,
            status: ::OrderStatus::Status[:adviser_sorted_out]
          }
        )
      end

      if ["photo_uploaded","attach_into_storage"].include?(params[:status]) && params[:scene] == "attach"
        @orders = @orders.has_attachment
      end

      if "delivery_manner_confirmed" == params[:status] 
        if params[:delivery_manner] == "express"
          @orders = @orders.where(delivery_manner: Order::DeliveryManner[:快递])
        else
          @orders = @orders.where.not(delivery_manner: Order::DeliveryManner[:快递])
        end
      end

      if "attach_into_storage" == params[:status] && params[:scene] == "repair"
        ot = Order.arel_table
        @orders = Order.joins(:customer).includes(:photos).where(
          ot[:status].eq(::OrderStatus::Status[:attach_into_storage]
        ).or(
          ot[:status].eq(::OrderStatus::Status[:photo_uploaded])
          .and(
              ot[:attachment].eq("").or(ot[:attachment].eq nil)
            )
          )
        )
      end
      @orders_count = @orders.count
      @orders = @orders.page(params).order_by_customer_name
    end

    desc "get gifts of orders  for IOS"
    get '/delivery_gifts', rabl: 'orders/concise' do     
       @orders = Order.joins(:customer).includes(:photos,:customer).where(
          status: OrderStatus::Status[:waiting_for_customer_receipt],
          delivery_manner:  Order::DeliveryManner[:包拯上门送]
        ).where.not(
          gift: nil
        ).where(
          "date(delivery_date) = date(now())"
        )
      @orders = @orders.order_by_customer_name
    end


    desc "get orders of user has handled"  
    get '/:user_id/distribution', rabl: 'orders/distribution' do 
      @os = ::OrderStatus.eager_load(:order, :user).where(
        status: ::OrderStatus::Status[params[:status].to_sym],
        user_id: params[:user_id] 
      ).where(
        :orders =>{status: ::OrderStatus::Status[params[:status].to_sym]}
      )
      @orders_count = @os.count
      @os = @os.page(params)
     end

    desc "get order by number with validation -> for IOS"
    get '/:number/validation', rabl: 'orders/validation' do
      wanted_status = ::OrderStatus::Status[params[:status].to_sym]
      factory_received = ::OrderStatus::Status[:factory_received]
      adviser_sorted_out = ::OrderStatus::Status[:adviser_sorted_out]
      photo_uploaded = ::OrderStatus::Status[:photo_uploaded]
      attach_into_storage = ::OrderStatus::Status[:attach_into_storage]
      @order = Order.where(number: params[:number]).first
      if @order
        customer_id = @order.customer_id
        @order_count = Order.where( 
          customer_id: customer_id,
          status: wanted_status
        ).count
        if @order.status != wanted_status
          if wanted_status == factory_received && @order.status == adviser_sorted_out
            user = @order.statuses.where(
              status: adviser_sorted_out
            ).first.try(:user).try(:name)
            @error_message = "该订单已被#{user}认领"
          else 
            if wanted_status == attach_into_storage && @order.status == photo_uploaded
              if !@order.has_no_attachment
                @error_message = "订单状态错误"
              end
            else
              @error_message = "订单状态错误"
            end
          end
        end
      else
        @error_message = "查无此订单信息"
      end
    end

    desc "get order by number with validation(for repair group) -> for IOS"
    get '/:number/repairation', rabl: 'orders/validation' do
      wanted_status = ::OrderStatus::Status[params[:status].to_sym]
      repairing = ::OrderStatus::Status[:repairing]
      repaired = ::OrderStatus::Status[:repaired]
      @order = Order.where(number: params[:number]).first
      if @order
        if @order.status != wanted_status
          if wanted_status == repairing && @order.status == repaired
            @error_message = "该订单已被确认修复完成"
          else
            @error_message = "订单状态错误"
          end
        else
          quality_testing = @order.quality_testings.last
          if wanted_status = repairing && quality_testing.present? && quality_testing.qualified
            @error_message = "该订单正在修复中" 
          end
        end
      else
        @error_message = "查无此订单信息"
      end
    end

    get '/:number/claim' do
      @order = Order.where(number: params[:number]).first
      pass = true
      if @order
        technologies = @order.technologies
        last_technology = @order.technologies.last
        user_ttype = current_user.ttype
        if technologies.present?
          if last_technology.ttype == user_ttype 
            if last_technology.approved
              pass = false
              message = "此工序已经完成"
            else
              if !last_technology.substituted
                if last_technology.user_id == current_user.id
                  pass = false
                  message = "当前工序已领取"
                else
                  pass = false
                  message = "当前工序已被他人领取"
                end
              end
            end
          else
            if !last_technology.approved
              pass = false
              message = "上一工序质检不合格"
            end 
          end
        end
        if @order.status != ::OrderStatus::Status[:repairing]
          pass = false
          message = "订单状态错误"
        end
      else
        pass = false
        message = "查无此订单信息"
      end
      to_do_number = Technology.repairings_of_user(current_user.id).count
      if pass
        message = "已领取#{to_do_number}个【#{Technology::TType.key(user_ttype)}】任务" 
      end
      {pass: pass, message: message }
    end

    desc "update customer‘s orders"
    put '/:id/auto_distribute' do
      order = Order.find(params[:id])
      order.handler_id = current_user.id
      other_orders = Order.where( 
        customer_id: order.customer_id,
        status: order.status
      ).where.not(id: order.id)
      order.goto_next_status
      other_orders.map do |other_order|
        other_order.handler_id = current_user.id
        other_order.auto_goto_next_status
      end
      return {value: true} 
    end

    desc "order goto the next status and create an express of this order ->for IOS"
    put '/:id/goto_next_status_with_express_info' do
      @order = Order.find(params[:id])
      @order.handler_id = current_user.id
      if  @order.express.present? 
        return  {error_message: "此订单已经有快递信息"}
       end
      unless params[:express_number] 
         return  {error_message: "快递单号不能为空"}
      end
      ActiveRecord::Base.transaction do
        @order.goto_next_status
        @order.create_delivery_express params
        return {value: true}
      end
    end

    desc "remove relations of orders with user"
    put '/:id/remove_distribution' do
      order = Order.find(params[:id])
      os = ::OrderStatus.joins(:order).where(
        status: ::OrderStatus::Status[:adviser_sorted_out],
        user_id: current_user.id 
      ).where(
        :orders => {
          status: ::OrderStatus::Status[:adviser_sorted_out],
          customer_id: order.customer_id
        }
      )
      os.map do |o|
        ActiveRecord::Base.transaction do
          o.order.back_to_last_status(current_user.id)
          o.destroy 
        end
      end 
      return {value: true} 
    end

    desc "get appointments and delivery_orders"
    get '/appointments' do
      completed = params[:completed]
      if completed == "true"
        results = Order.get_completed_appointment_info
      else
        results = Order.get_appointment_info
      end
      return {values: results}
    end

    desc "update an order which delivery with trouble"
    put '/:id/delivery_trouble'do
      @order = Order.find(params[:id])
      @order.handler_id = current_user.id
      ActiveRecord::Base.transaction do
        @order.update_delivery_trouble(params)
        @order.goto_next_status
      end
      return {value:true}
    end
   
    desc "batch order goto the next status"
    put '/batch_goto_next_status' do
      ActiveRecord::Base.transaction do
        params[:ids].each  do |id|
          @order = Order.find(id)
          @order.handler_id = current_user.id
          @order.goto_next_status
        end
      end
      {value: true}
    end

    desc "order blue_print_test"
    put '/blue_print_testing' do 
      @order = Order.find(params[:order][:id])
      @order.handler_id = current_user.id
      ActiveRecord::Base.transaction do
        @order.update_attributes!(blue_print_passed: params[:order][:blue_print_passed])
        if params[:order][:blue_print_passed] == "1"
          @order.goto_next_status
        else
          @order.back_to_last_status
        end
      end
      return {value: true}
    end

    desc "order goto the next status"
    put '/:id/goto_next_status', rabl: 'orders/order_status' do
      @order = Order.find(params[:id])
      @order.handler_id = current_user.id
      @order.goto_next_status
    end

    desc "order back to the last status"
    put '/:id/back_to_last_status', rabl: 'orders/order_status' do
      @order = Order.find(params[:id])
      @order.handler_id = current_user.id
      @order.back_to_last_status
    end

    desc 'return order count by status'
    get '/count_by_status', rabl: 'orders/count_by_status' do
      params[:type] ||= 'all'

      @orders = Order.
        send(params[:date_scope]).
        filter_by_date(params[:start_date], params[:end_date])

      @type_orders = @orders.send(params[:type])

      @count = @type_orders.group(:status).count
      @count.merge!( -1 => @type_orders.count)
    end

    desc 'fetch and delivery detail'
    get '/fetch_delivery_detail', rabl: "orders/customer_fetch_delivery_info" do
      @customers, @from, @customer_ids = Order.get_fetch_delivery_info(params)
      @items = 0
      @customers.each do |customer|
        @items += customer.orders.size
      end
    end

    get '/get_send_count' do
      orders = Order.where(
        "(fetch_date = :date and pickup_manner = 1) or
        (delivery_date = :date and delivery_manner = 2)",
        date: params[:date]
      )
      {order_count: orders.count}
    end

    get '/reworks', rabl: 'orders/reworks' do
      @worker_reworks = Order.worker_reworks.includes(:technologies)
      @solu_reworks = Order.solu_reworks.includes(:technologies)
    end

    get '/storage_operations', rabl: 'orders/storage_operations_list' do
      @orders = Order.where(
        status: ::OrderStatus::Status[params[:current_status].to_sym],
        pre: false,
        cancel: false
      )
      if params[:current_status].to_s == "waiting_for_customer_receipt"
        @orders = @orders.where(delivery_manner: [0, 1])
      end
      @next_status = params[:next_status]
    end

    get '/:number/storage_operations', rabl: 'orders/storage_operations' do
      @order = Order.where(number: params[:number]).first
      @next_status = params[:next_status]
    end

    get '/reconciliations', rabl: "orders/reconciliation" do
      to = Time.zone.now
      case params[:from]
      when 'today'
        from = Time.zone.now.beginning_of_day
      when 'week'
        from = Time.zone.now.beginning_of_week
      when 'month'
        from = Time.zone.now.beginning_of_month
      else
        from = Time.parse(params[:from])
        to = Time.parse(params[:to])
      end
      @os = Order.paid.filter_by_date(from, to)
      @orders = @os.includes(:item).includes(:customer).
        includes(:activity).includes(:refunds).includes(:settlement)

      @count = @os.count
      @total = @os.select('sum(final_price)/100.0 as total').first.total
    end

    desc 'return overdue infomation of order which is overdue'
    get '/overdue', rabl: 'overdues/overdues_for_order' do
      @order = Order.where(id: params[:order_id])
      @overdues = Overdue.where(order_id: params[:order_id]).order("expected_date desc")
    end


    post '/overdue' do
      @overdue = Overdue.new(Overdue.permit(params[:overdue]))
      @result = @overdue.save
      return @result
    end

    desc "return orders by search type"
    get '/types', rabl: 'orders/type_orders' do
      @customer = Customer.find(params[:customer_id])
      @orders = @customer.orders.includes(
        :activity, :item, :refunds
      ).send(params[:type]).order('paid asc, id desc')
    end

    desc 'return uncompleted orders for a customer'
    get '/uncompleted', rabl: 'orders/uncompleted' do
      @customer = Customer.find(params[:customer_id])
      @orders = @customer.orders.includes(:activity).
        includes(:refunds).order('paid asc').order("id desc")

      case params[:order_type]
      when '0'
        @orders = @orders.uncompleted
      when '1'
        @orders = @orders.completed
      end
    end

    desc 'return unpaid orders for a customer'
    get '/unpaid', rabl: 'orders/unpaid' do
      @customer = Customer.find(params[:customer_id])
      @orders = @customer.orders.unpaid.includes(:activity).
        includes(:refunds).order("id desc")
    end

    desc "update an order"
    route_param :id do
      put '/' do
        @order = Order.find(params[:order][:id])
        @order.updated_by(current_user, params[:order])
        log = @order.logs.order('id desc').first
        {
          order: object_to_hash(
            @order.reload, :price, :discount, :final_price, :show_item_type, :show_style, :show_color, :show_brand, :show_activity_info
          ), 
          log: object_to_hash(
            log, :show_type, :show_time, :changed_values, :user_name, :id
          )
        }
      end
    end

    desc 'create new order'
    params do
      # requires :status, type: String, desc: "Your status."
    end
    post '/', rabl: 'orders/order_for_pay' do
      @order = Order.where(number: params[:order][:number]).first
      if @order
        @error_message = "order number already exists"
      else
        @order = Order.create_order_by(current_user, params[:order])
      end
    end

    desc "return orders counts for orders list page"
    get '/list_counts', rabl: "orders/list_counts" do
    end

    desc 'return orders list'
    get '/', rabl: "orders/index" do
      ap params if Rails.env.development?
      @orders = Order.
        filter_order_by_type(params[:type]).
        filter_by_handler(params[:handler]).
        filter_by_zh_status(params[:status]).
        filter_by_date_range_or_scope(params).
        filter_by_keyword(params[:query_str]).
        includes(:item, :customer, :statuses).
        order_by(params[:order_by], params[:order_desc])
      @searched_count = @orders.count
      @paged_orders = @orders.page(params)
    end

    desc "cancel an Order."
    params do
      requires :id, type: String, desc: "Order ID."
    end

    put ':id/cancel' do
      @order = Order.find(params[:order][:id])


      ActiveRecord::Base.transaction do

        @order.update_attributes!(Order.permit_by(params))

        if Friend.permit_by(params[:order]).present?
          f = Friend.create!(Friend.permit_by(params[:order]))
          @order.update_attributes!(friend_id: f.id)
        end

        if Address.permit_by(params[:order], :delivery_address) && @order.delivery_address
          @order.delivery_address.update_attributes!(
            Address.permit_by(params[:order], :delivery_address)
          )
        end

        if Refund.permit_by(params[:order]).present?
          refund = @order.refunds.create!(Refund.permit_by(params[:order]))
          if refund.pm == ConsumptionRecord::PaymentMethod[:会员卡]
            customer = @order.customer.balance_increase_by(refund.amount)
          end
        end

        @order.logs.create!(
          handle_type: 'Update', 
          user_id: current_user.id,
          changed_values: @order.all_changed
        ) unless @order.all_changed.blank?
      end
    end

    put ':id/refund' do
      @order = Order.find(params[:order][:id])
      ActiveRecord::Base.transaction do
        @order.update_attributes!(Order.permit_by(params))

        if Friend.permit_by(params[:order]).present?
          f = Friend.create!(Friend.permit_by(params[:order]))
          @order.update_attributes!(friend_id: f.id)
        end

        if Address.permit_by(params[:order], :delivery_address) && @order.delivery_address
          @order.delivery_address.update_attributes!(
            Address.permit_by(params[:order], :delivery_address)
          )
        end

        if Refund.permit_by(params[:order]).present?
          refund = @order.refunds.create!(Refund.permit_by(params[:order]))
          if refund.pm == ConsumptionRecord::PaymentMethod[:会员卡]
            customer = @order.customer.balance_increase_by(refund.amount)
          end
        end

        @order.logs.create!(
          handle_type: 'Update', 
          user_id: current_user.id,
          changed_values: @order.all_changed
        ) unless @order.all_changed.blank?
      end

      @order
    end

    put ':id/abnormal' do
      @order = Order.find(params[:order_id])
      info = params[:info]
      ActiveRecord::Base.transaction do
        @order.update_attributes!(abnormal: params[:abnormal])
        if params[:abnormal]
          handle_type = "Abnormal"
        else
          handle_type = "RidAbnormal"
        end
        @order.logs.create!(
          handle_type: handle_type,
          user_id: current_user.id,
          attrs: "updated_at|abnormal",
          changed_values: info
        )
      end
    end

    delete ':id/delete_with_reason' do
      @order = Order.find(params[:id])
      ActiveRecord::Base.transaction do
        @order.destroy
        @order.logs.create!(
          handle_type: 'Delete',
          user_id: current_user.id,
          changed_values: { "删除原因" => params[:reason] }
        )
      end
    end

    desc "Delete an Order."
    params do
      requires :id, type: String, desc: "Order ID."
    end
    delete ':id' do
      @order = Order.find(params[:id])
      @order.destroy
    end

    desc "return an order by order id"
    # params { requires :id, type: Integer, desc: "User id" }

    route_param :id do
      get '/', rabl: 'orders/show_order', authorize: true do
        if params[:id].to_s.length > 13
          @order = Order.where(number: params[:id]).first
        elsif params[:id].to_i.to_s == params[:id]
          @order = Order.where(id: params[:id]).first
        end
        @order ||= Order.find_by_encrypted_id(params[:id])
        @log = params[:log] == 'true'
      end
    end

  end

end
