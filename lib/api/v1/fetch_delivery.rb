class API::V1::FetchDelivery < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  # before do
    # authenticate!
  # end
  # helpers do
  # end

  resource :fetch_delivery do

    desc "return all fetch and delivery"
    get '/' do
      fetch_address_ids = Order.need_fetch.before_today.pluck(:fetch_address_id)
      delivery_address_ids = Order.need_delivery.before_today.pluck(:delivery_address_id)
      @addresses = Address.where(id:  fetch_address_ids + delivery_address_ids)
      @addresses += Address.where(
        addressable_type: "Appointment", 
        addressable_id: Appointment.unfinished.before_today.pluck(:id)
      )
    end

  end

end
