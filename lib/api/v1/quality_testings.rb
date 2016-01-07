class API::V1::QualityTestings < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:quality_testing]).permit(
        :technology_id, :tester_id, :qualified, :remark, :refer, :order_id
      )
    end
  end

  resource :quality_testings do
    desc "query order by order number and show last_unqualified quality_testing info "
    get '/:order_number/order_technology_info', rabl: 'quality_testings/order_technology_info' do
      @order = Order.find_by_number(params[:order_number])
      if @order
        @technology = @order.current_technology
        @quality_testing = @order.last_unqualified
        if @order.status != ::OrderStatus::Status[:repairing]
          @error_message = "订单状态错误"
        end
      else
        @error_message = "查无此订单信息"
      end
    end

    desc 'create new quality_testing'
    params do
      # requires :status, type: String, desc: "Your status."
    end

    post '/', rabl: 'quality_testings/show' do
      @technology = Technology.find(permitted_params[:technology_id])
      @quality_testing = @technology.quality_testings.create!(
        permitted_params.merge!(order_id: @technology.order_id, tester_id: current_user.id)
      )
    end

    desc "Update a QualityTesting."
    params do
      requires :id, type: String, desc: "QualityTesting ID."
    end
    put ':id', rabl: 'quality_testings/show' do
      @quality_testing = QualityTesting.find(params[:id])
      @quality_testing.update_attributes!(permitted_params)
    end


    desc "Delete a QualityTesting."
    params do
      requires :id, type: String, desc: "QualityTesting ID."
    end

    delete ':id' do
      @quality_testing = QualityTesting.find(params[:id])
      @quality_testing.destroy
    end

  end

end
