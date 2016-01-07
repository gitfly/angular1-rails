class API::V1::Orderitem < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authorize!(@action, @object)
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:orderitem]).permit()
    end
  end

  resource :orders do
    # get '/reconciliations', rabl: "orders/index" do
    # end
  end
end
