class API::V1::ConsumptionRecords < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:consumption_record]).permit(
        :amount, :payment_method, :remark, :customer_id, :consumptions
      ).tap do |whitelisted|
        whitelisted[:order_ids] = params[:consumption_record][:order_ids]
      end
    end
  end

  resource :consumption_records do

    desc 'create new consumption record'
    params do
      # requires :status, type: String, desc: "Your status."
    end

    post '/', rabl: 'customers/show' do
      @customer = Customer.find(permitted_params[:customer_id])
      if params[:consumption_record][:consumptions]
        @customer.multiple_consume(params[:consumption_record][:consumptions])
      else
        @consumption_record = @customer.consume(permitted_params)
      end

      @customer.reload
    end

  end

end
