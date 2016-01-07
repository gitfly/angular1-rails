class API::V1::Recharges < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:recharge]).
        permit(:amount, :pm, :content, :customer_id, :bonus, :discount)
    end
  end

  resource :recharges do

    desc 'create new consumption record'
    params do
      # requires :status, type: String, desc: "Your status."
    end

    post '/', rabl: 'recharges/show' do
      @customer = Customer.find(permitted_params[:customer_id])
      @recharge = @customer.recharges.create!(permitted_params)

      @orders = @customer.orders.includes(
        :activity, :item, :refunds
      ).send(params[:recharge][:order_type]).order('paid asc, id desc')
    end

  end

end
