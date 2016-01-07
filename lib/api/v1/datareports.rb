class API::V1::Datareports < Grape::API
  include API::V1::Helpers
  # include Grape::Kaminari

  # doorkeeper_for :all

  before do
    # authorize!(@action, @object)
  end

  helpers do

  end

  resource :datareports do

    get '/report_home' do
      @results = Order.packaging_data(params)
      # @results = Order.get_report_home_datas(params)
      @from, @to = Order.packaging_date(params)
      return [@results, @from.strftime("%Y-%m-%d"), @to.strftime("%Y-%m-%d")]
    end

    desc 'export cvs of report_home'
    get '/report_home/export' do
      Order.export_data(params)
      content_type "application/octet-stream"
      header['Content-Disposition'] = "attachment; filename=report_home_#{(Time.zone.now).strftime('%Y-%m-%d_%H:%M:%S').to_s}.xlsx"
      env['api.format'] = :binary
      File.open('tmp/report_home.xlsx').read
    end

    get '/orderitems', rabl: "data_reports/orderitem" do
      @orders, @from, @to = Order.getOrderItem(params, false)
      @pre_count = @orders.where(pre: true).count
      @formal_count = @orders.where(pre: false).count
      @orders_count = @orders.count
      @orders = @orders.limit(100)
    end

    desc 'export cvs of orderitem'
    get '/orderitems/export' do
      Order.exportOrderItem(params, false)
      content_type "application/octet-stream"
      header['Content-Disposition'] = "attachment; filename=orderitem_#{(Time.zone.now).strftime('%Y-%m-%d_%H:%M:%S').to_s}.xlsx"
      env['api.format'] = :binary
      File.open('tmp/report_export.xlsx').read
    end

    get '/payment_details', rabl: "data_reports/orderitem" do
      @orders, @from, @to = Order.getOrderItem(params, true)
      @total_amounts, @pm_amounts_hash = Order.getIncomeDetial(@orders)
      @orders_count = @orders.count
      @orders = @orders.limit(100)

    end

    desc 'export cvs of payment_details'
    get '/payment_details/export' do
      Order.exportOrderItem(params, true)
      content_type "application/octet-stream"
      header['Content-Disposition'] = "attachment; filename=payment_details_#{(Time.zone.now).strftime('%Y-%m-%d_%H:%M:%S').to_s}.xlsx"
      env['api.format'] = :binary
      File.open('tmp/report_export.xlsx').read
    end

    get '/customer_details', rabl: "data_reports/customer_detail" do
      @new_customers = @old_customers = 0
      @customers, @from, @to = Customer.getCustomerDetails(params)
      @customers.each do |customer|
        if customer.consumption_times == 1
          @new_customers += 1
        elsif customer.consumption_times > 1
          @old_customers += 1
        end

      end
      @orderd_customers = @customers.length
      @customers = @customers.limit(100)
    end

    desc 'export cvs of orderitem'
    get '/customer_details/export' do
      Customer.exportCustomerDetails(params)
      content_type "application/octet-stream"
      header['Content-Disposition'] = "attachment; filename=customer_detail_#{(Time.zone.now).strftime('%Y-%m-%d_%H:%M:%S').to_s}.xlsx"
      env['api.format'] = :binary
      File.open('tmp/customer_detail.xlsx').read
    end

    get '/overdue_orders', rabl: "data_reports/overdues_for_report"do

      @from = @date_param =params[:from]
      if @date_param
        @date_param = Time.parse(@date_param) - 1.day
        @from = Time.parse(@from)
      else
        @date_param = Time.zone.now.beginning_of_day - 1.day
        @from = Time.zone.now.beginning_of_day
      end
      overdue_orders = Order.where(pre: false, cancel: false)
      .where.not("orders.status < #{::OrderStatus::Status[:into_storage]}")
      .where("date(DATE_ADD(finish_date,INTERVAL -2 DAY)) = date('#{@date_param}')")

      @should_finished_orders = Order
      .where(pre: false, cancel: false)
      .where("date(DATE_ADD(finish_date,INTERVAL -2 DAY)) = date('#{@date_param}')")

      @overdues = Overdue
      .joins(:order)
      .where("date(DATE_ADD(original_date,INTERVAL -2 DAY))=date('#{@date_param}')")
      .where(:orders => {pre: false, cancel: false})
      .where("orders.status < #{::OrderStatus::Status[:into_storage]}")

      overdue_orders.each do |order|
        overdues = Overdue.where(order_id: order.id).to_a
        if overdues.length == 0
          puts overdues
          overdue = Overdue.new
          overdue.order_id = order.id
          overdue.original_date = order.finish_date
          @overdues << overdue
        end
      end

    end

  end

end
