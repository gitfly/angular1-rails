class API::V1::Services < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:service]).permit(:name, :price)
    end
  end

  resource :services do

    desc "return service types"
    get '/types' do
      Service.select(
        "CONCAT(CONCAT(services.name, '-'), services.price) as a"
      ).map(&:a)
    end

    desc 'return a services'
    params { requires :id, type: Integer, desc: "User id" }

    route_param :id do
      get '/', rabl: 'services/show' do
        @service = Service.find(params[:id])
      end
    end

    get '/', rabl: 'services/index' do
      @services = Service.order('id desc')
    end

    desc 'create new service'
    params do
      # requires :status, type: String, desc: "Your status."
    end

    post '/', rabl: 'services/show' do
      @service = Service.create!(permitted_params)
    end

    desc "Delete a service."
    params do
      requires :id, type: String, desc: "Service ID."
    end

    delete ':id' do
      @service = Service.find(params[:id])
      @service.destroy
    end

  end

end
