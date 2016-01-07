class API::V1::Friends < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:friend]).permit(
        :customer_id, :name, :phone, :weixin
      )
    end
  end

  resource :friends do

    desc 'return a friend'  #, auth: { scopes: ['public'] }

    # params { requires :id, type: Integer, desc: "User id" }

    route_param :id do
      get '/', rabl: 'friends/show' do
        @friend = Friend.find(params[:id])
      end
    end

    desc 'create new friend'
    params do
      # requires :status, type: String, desc: "Your status."
    end

    post '/' do
      customer = Customer.find(params[:friend][:customer_id])
      customer.friends.create!(permitted_params)
    end


  end

end
