class API::V1::Addresses < Grape::API
  include API::V1::Helpers

  # doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_address_params
      ActionController::Parameters.new(params[:address]).permit(
        :country, :province, :city, :details, :customer_id, :name, :phone
      )
    end
  end

  resource :addresses do

    desc "return all districts of a city"
    get '/districts' do
      City.where(name: params[:city]).first.districts.pluck(:name)
    end

    desc "return all cities of a province"
    get '/cities' do
      Province.where(name: params[:province]).first.cities.pluck(:name)
    end

    desc "return all provinces"
    get '/provinces' do
      Province.pluck(:name)
    end

    get '/', rabl: 'addresses/index' do
      @customer = Customer.find(params[:customer_id])
      @addresses = @customer.addresses.useful
    end

    desc 'create new address'
    params do
      # requires :status, type: String, desc: "Your status."
    end
    post '/' do
      @customer = Customer.find(params[:address].delete(:customer_id))
      @customer.addresses.create!(permitted_address_params)
    end

  end

end
