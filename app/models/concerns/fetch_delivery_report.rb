module FetchDeliveryReport
  extend ActiveSupport::Concern

  module ClassMethods

    def get_fetch_delivery_info(params)
      from = params[:from]
      if !from
        from = Time.now.strftime("%Y-%m-%d")
      else
        from = from.to_date.strftime("%Y-%m-%d")
      end

      # fetch_customers = Customer.includes(:orders).includes(:items).where(:orders =>{
      #   pickup_manner: ::Order::PickupManner[:"包拯上门取"], 
      #   fetch_date: from,
      #   cancel: false,
      #   status: ::OrderStatus::Status[:waiting_for_pickup] 
      # })

      # delivery_customers = Customer.includes(:orders).includes(:items).where(:orders =>{
      #   delivery_manner: ::Order::DeliveryManner[:"包拯上门送"], 
      #   delivery_date: from,
      #   cancel: false,
      #   status: ::OrderStatus::Status[:delivery]
      # })

      fetch_customers = Customer.includes(:orders).includes(:items).where(:orders =>{
        pickup_manner: ::Order::PickupManner[:"包拯上门取"], 
        fetch_date: from,
        cancel: false,
        pre: true
      })



      delivery_customers = Customer.includes(:orders).includes(:items).where(:orders =>{
        delivery_manner: ::Order::DeliveryManner[:"包拯上门送"], 
        delivery_date: from,
        cancel: false
      })
      fetch_customers_hash = Hash[fetch_customers.map { |customer| [customer.id, customer] }]
      delivery_customers_hash = Hash[delivery_customers.map { |customer| [customer.id, customer] }]

      fetch_delivery_info = []
      customer_ids = (fetch_customers_hash.keys | delivery_customers_hash.keys).sort
      customer_ids.each do |id| 
        if fetch_customers_hash[id]
          fetch_delivery_info << fetch_customers_hash[id]
        end

        if delivery_customers_hash[id]
          fetch_delivery_info << delivery_customers_hash[id]
        end

      end
      return [fetch_delivery_info, from, customer_ids]
    end 
  end

end