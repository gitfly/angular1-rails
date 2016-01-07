class API::V1::Warehouses < Grape::API
  include API::V1::Helpers
  # include Grape::Kaminari

  # doorkeeper_for :all

  before do
    # authorize!(@action, @object)or
  end

  helpers do
    
  end

  resource :warehouses do

    
    get '/store', rabl: "warehouses/glance" do
      # 门店入库
      @advance_order = Order.get_advance_order()  
      # 送去修复中心
      @send_to_factory = Order.get_send_to_factory()
      # 修复中心接收
      @factory_receive = Order.get_factory_receive()
      # 修复中心发出
      @out_of_storage = Order.get_out_of_storage()
      # 门店接收
      @store_receive = Order.get_store_receive()
      # 门店出库
      @complete = Order.get_complete()
      # 异常订单
      @abnormal_orders = Order.get_abnormal()
    end

    
  end

end
