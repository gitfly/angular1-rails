class API::V1::Items < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:item]).permit(
        :customer_id, :color_id, :color, :scale, :version, 
        :brand, :type
      )
    end
  end

  resource :items do

    get '/versions' do
      Item.filter_by(version: params[:version], brand: params[:brand])
    end

    get '/brands' do
      Item.filter_by(brand: params[:brand])
    end

    get '/colors' do
      Item.filter_by(color: params[:color])
    end

  end

end
