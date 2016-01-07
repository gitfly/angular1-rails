class API::V1::OrderLogs < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:order_log]).permit(
        :attributes, :handle_type, :user_id, :order_id
      )
    end
  end

  resource :order_logs do

    get '/', rabl: 'order_logs/index' do
      @order = Order.find(params[:order_id])
      @logs = @order.logs.includes(:user).order('id desc')
    end

    get ':id/load_more', rabl: 'order_logs/index' do
      @order = Order.find(params[:order_id])
      @logs = @order.logs.where("id > #{params[:id]}").includes(:user).order('id desc')
    end

  end

end
