class API::V1::OrderStatus < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(
        params[:order_status]
      ).permit(:order_id, :status)
    end
  end

  resource :order_statuses do

    desc "return handler of a specified status change"
    get '/:order_id/handler' do
      @order = Order.find(params[:order_id])
      handler = @order.last_handler_for_status(params[:status])
      { name: handler.try(:name), id: handler.try(:id) }
    end

    desc 'create new order status'
    params do
      # requires :status, type: String, desc: "Your status."
    end
    post '/', rabl: 'orders/show' do
      @order = Order.find(permitted_params[:order_id])
      @order.handler_id = current_user.id
      @order.update_status_by_name(permitted_params[:status])
    end

  end

end

