class API::V1::Customers < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:customer]).permit(
        :name, :email, :weixin, :avatar, :balance, :phone, 
        :weixin_nickname, :birthday, :gender, :job, :source, 
        :service_number, :sensitivity, :tags, :sub_source
      )
    end

    def permitted_referrer_params
      ActionController::Parameters.new(params[:customer][:referrer]).permit(
        :name, :weixin, :weixin_nickname, :phone
      )
    end
  end

  resource :customers do

    desc "return customer source"
    get "/sub_source" do
      Customer.where(
        "source like ? and sub_source like ?", 
        "%#{params[:source]}%", "%#{params[:sub_source]}%"
      ).group(:sub_source).limit(20).pluck(:sub_source)
    end

    desc "return customer source"
    get "/source" do
      Customer.group(:source).where(
        "source like ?", "%#{params[:source]}%"
      ).limit(20).pluck(:source)
    end

    desc "get unfinished orders of a customer"
    get '/:id/unfinished_orders', rabl: 'customers/unfinished_orders' do
      @customer = Customer.find(params[:id])
      @counts = @customer.orders.group('paid').count
      @orders = @customer.orders.includes(:item).group_by{ |order| order.paid }
    end

    desc "get orders of a customer"
    get '/:id/orders', rabl: 'customers/orders' do
      @customer = Customer.find(params[:id])
      @counts = @customer.orders_count_by_status if params[:with_counts] == 'true'
      @orders = @customer.orders.where(
        status: OrderStatus::Status[I18n.t("order.status").key(params[:status])]
      ).order('created_at desc').includes(:item)
    end

    desc "get orders of a customer for pay(for IOS)"
    get '/:id/orders_for_pay', rabl: 'customers/orders_for_pay' do
      @customer = Customer.find(params[:id])
      @orders = @customer.orders.where(
        status: OrderStatus::Status[params[:status].to_sym],
        delivery_manner: Order::DeliveryManner[params[:delivery_manner].to_sym]
      ).order('created_at desc').includes(:item)
      @orders_count = @orders.count
      @order_ids = []
      @amount = 0.0
      @orders.each do |o| 
        unless o.paid
          @amount += o.final_price
          @order_ids << o.id
        end
      end
    end

    desc "query customer by name phone or email"
    get '/info', rabl: "customers/info" do
      q = "#{params[:q]}%"
      @customers = Customer.where("name like ? or phone like ? or weixin like ?", q, q, q).limit(8)
    end

    desc "validate customer attributes" 
    get '/exists' do
      Customer.where(params[:attr] => params[:value]).exists?
    end

    desc "query customer by name phone or weixin"
    get '/verify', rabl: "customers/info" do
      phone = params[:phone]
      weixin = params[:weixin]
      if phone
        @customers = Customer.where(phone: phone)
      end

      if weixin
        @customers = Customer.where(weixin: weixin)
      end
        
    end

    desc "return an customer by customer id"
    params { requires :id, type: Integer, desc: "Customer id" }
    route_param :id do
      get '/', rabl: 'customers/show' do
        @customer = Customer.find(params[:id])
        @with_address = params[:with_address]
      end
    end

    desc "query customer by name, and return an array of matched customer name"
    get '/names/:name', rabl: "customers/names" do
      @customers = Customer.where("name like ?", "%#{params[:name]}%").limit(10)
    end

    get '/names', rabl: "customers/names" do
      @customers = Customer.limit(30)
    end

    desc "return all customers order by created_at desc"
    get '/', rabl: 'customers/index' do
      # @customers = Customer.order('created_at desc')
      str = params[:q]
      @customers = Customer.where{(name =~ "%#{str}%") | (phone =~ "%#{str}%") | (email =~ "%#{str}%")}.includes(:orders).limit(20)
    end

    desc 'create new customer'
    params do
      # requires :status, type: String, desc: "Your status."
    end
    post '/', rabl: 'customers/show' do
      email = permitted_params[:email]
      email = "#{SecureRandom.hex(6)}@baozheng.cc" if email.blank?
      @customer = Customer.create!(permitted_params.merge(email: email))
      # @referrer = @customer.friends.create!(permitted_referrer_params.merge(ftype: 0))
    end

    desc 'create new customer if customer not exists'
    post '/create_with_validation', rabl: 'customers/customer_with_appointment' do
      phone = permitted_params[:phone]
      @customer = Customer.where(phone:phone).first
      unless @customer
        email = "#{SecureRandom.hex(6)}@baozheng.cc"
        @customer = Customer.create!(permitted_params.merge(email: email))
      end
      @appointment = @customer.appointments.create(date: Time.zone.now, atype: 0)
    end

    desc "Update a Customer."
    params do
      requires :id, type: String, desc: "Customer ID."
      # requires :status, type: String, desc: "Your status."
    end
    put ':id', rabl: 'customers/show' do
      @customer = Customer.find(params[:customer][:id])
      old_source = @customer.source
      @customer.update_attributes!(permitted_params)
      if old_source != params[:customer][:source] && params[:customer][:source] == 2
         @referrer = @customer.friends.create!(permitted_referrer_params.merge(ftype: 0))
      end
      
      if old_source == params[:customer][:source] && old_source == 2
         @referrer = @customer.referrer.update_attributes!(permitted_referrer_params.merge(ftype: 0))
      end

    end
  end

end
