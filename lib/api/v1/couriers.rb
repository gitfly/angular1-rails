class API::V1::Couriers < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  # before do
    # authenticate!
  # end
  # helpers do
  # end

  resource :couriers do

    desc "return all couriers"
    get '/' do
      Courier.all.order("id desc")
    end

  end

end
