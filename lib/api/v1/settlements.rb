class API::V1::Settlements < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:settlement]).permit(
        :amount, :customer_id, :user_id, :order_id, order_ids: [], pay_records: []
      ).tap do |hash|
        hash[:pay_records] = params[:settlement][:pay_records]
      end
    end
  end

  resource :settlements do

    desc 'create new settlement'
    params do
      # requires :status, type: String, desc: "Your status."
    end
    post '/', rabl: 'orders/types' do
      ActiveRecord::Base.transaction do
        settlement = Settlement.pay(permitted_params, current_user)
       @customer = settlement.customer
       @orders = settlement.customer.orders.unpaid.
        includes(:activity).includes(:refunds).order("id desc")
      end  
    end
  end

end