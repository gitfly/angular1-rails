class Address < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :addressable, polymorphic: true

  attr_accessor :handler_id
  attr_accessor :current_logger
  
  scope :useful, -> { where("details != ''").group('details') }

  Atype = {
    fetch_address: 0, 
    delivery_address: 1
  }

  def orders
    Order.where("#{Atype.key(atype)}_id": id)
  end

  def show_address
    if province == city
      "#{city}#{district}#{details}"
    else
      "#{province}#{city}#{district}#{details}"
    end
  end
  alias :show :show_address

  private 

    # def update_address_for_orders_belongs_to_customer
    #   _orders = orders.first.customer.orders.uncompleted
    #   if atype == Atype[:fetch_address]
    #     _orders.update_all(
    #       fetch_address_id: id, pickup_manner: self.order.pickup_manner
    #     )
    #   elsif atype == Atype[:delivery_address]
    #     _orders.update_all(
    #       delivery_address_id: id, delivery_manner: self.order.delivery_manner
    #     )
    #   end
    # end

  #   def order_updated
  #     binding.pry
  #     current_logger.update_attributes!(
  #       changed_values: current_logger.changed_values.merge!(
  #       )  
  #     ) if current_logger
  #   end

end
