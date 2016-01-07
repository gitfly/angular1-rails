module WarehouseFlow
  extend ActiveSupport::Concern

  module ClassMethods
    # 门店入库
    def get_advance_order
      advance_order = Order.joins(:statuses).where( 
        status: ::OrderStatus::Status[:advance_order],
        pre: false,
        cancel: false, 
        pickup_manner: [::Order::PickupManner[:亲自来店], ::Order::PickupManner[:快递寄来]]
      ).where(
        "date(order_statuses.created_at)=date(now())"
      ).where(:statuses => {
        status: ::OrderStatus::Status[:advance_order]
      }).ids

      return advance_order
    end   
      # 送去修复中心
    def get_send_to_factory
      send_to_factory = Order.joins(:statuses).where(
        status: ::OrderStatus::Status[:send_to_factory],
        cancel: false
      ).where(
        "date(order_statuses.created_at)=date(now())"
      ).where(:statuses => {
        status: ::OrderStatus::Status[:send_to_factory]
      }).ids
      return send_to_factory
    end
      

      # 修复中心接收
    def get_factory_receive
       factory_receive = Order.joins(:statuses).where(
        status: ::OrderStatus::Status[:factory_receive],
        cancel: false
      ).where(
        "date(order_statuses.created_at)=date(now())"
      ).where(:statuses => {
        status: ::OrderStatus::Status[:factory_receive]
      }).ids
      return factory_receive
    end 
      
      # 修复中心发出

    def get_out_of_storage
      out_of_storage = Order.joins(:statuses).where(
        status: ::OrderStatus::Status[:out_of_storage],
        cancel: false,
        delivery_manner: ::Order::DeliveryManner[:顾客来店取]
      ).where(
        "date(order_statuses.created_at)=date(now())"
      ).where(:statuses => {
        status: ::OrderStatus::Status[:out_of_storage]
      }).ids
      return out_of_storage
    end
      
      # 门店接收
    def get_store_receive
      store_receive = Order.joins(:statuses).where(
        status: ::OrderStatus::Status[:store_receive],
        cancel: false
      ).where(
        "date(order_statuses.created_at)=date(now())"
      ).where(:statuses => {
        status: ::OrderStatus::Status[:store_receive]
      }).ids
      return store_receive
    end

      # 门店出库
    def get_complete
      complete = Order.joins(:statuses).where(
        status: ::OrderStatus::Status[:complete],
        cancel: false,
        delivery_manner: [::Order::DeliveryManner[:顾客来店取], ::Order::DeliveryManner[:朋友来店代取]]
      ).where(
        "date(order_statuses.created_at)=date(now())"
      ).where(:statuses => {
        status: ::OrderStatus::Status[:complete]
      }).ids
      return complete
     
    end

    def get_abnormal
      abnormal = Order.where(abnormal: true)
      return abnormal
    end 
    
  end

end