class API::V1::Technologies < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:technology]).permit(
        :ttype, :order_id, :remark, :end_time, :user_id, :substituted
      )
    end
  end

  resource :technologies do

    desc "select an user(worker) uncompleted list"
    get '/repairings', rabl: 'technologies/list' do
      @technologies = Technology.repairings_of_user(current_user.id)
      @count = @technologies.count
      @technologies = @technologies.order("orders.urgent desc, orders.created_at asc").page()
    end

    desc "select an user(worker) completed list"
    get '/completed', rabl: 'technologies/list' do
      @technologies = Technology.completed_of_user_today(current_user.id)
      @count = @technologies.count
      @technologies = @technologies.order("orders.urgent desc, orders.created_at asc").page()
    end

    get '/:id', rabl:'technologies/detail' do
      @technology = Technology.find(params[:id])
      @unqualified = @technology.last_unqualified_quality_testings
    end



    desc "return unqualified quality_testing"
    get '/:technology_id/unqualified_quality_testings', rabl: 'technologies/index' do
      @technology = Technology.find(params[:technology_id])
      @technologies = Technology.where(
        repeated: 1,
        ttype: @technology.ttype,
        order_id: @technology.order_id,
      ).includes(:quality_testing)
    end

    desc "return unqualified technologies"
    get '/:technology_id/unqualified', rabl: 'technologies/unqualified' do
      @technology = Technology.find(params[:technology_id])
      @technologies = Technology.where(
        repeated: 1,
        ttype: @technology.ttype,
        order_id: @technology.order_id,
      )
    end

    desc "return technologies"
    get '/', rabl: 'technologies/index' do
      @order = Order.find(params[:order_id])
      @technologies = @order.technologies
      @technologies = @technologies.unrepeated unless params[:all]
    end

    desc 'create new technology'
    params do
      # requires :status, type: String, desc: "Your status."
    end

    post '/', rabl: 'technologies/show' do
      @order = Order.find(permitted_params[:order_id])

      @technology = @order.technologies.create!(
        user_id: current_user.id, 
        ttype: current_user.ttype
      )
    end



    desc "Update a Technology."
    params do
      requires :id, type: String, desc: "Technology ID."
    end
    put ':id', rabl: 'technologies/show' do
      @technology = Technology.find(params[:id])
      if params[:technology][:end].try(:to_s) == 'true'
        params[:technology][:end_time] = Time.now
      end
      @technology.update_attributes!(permitted_params)
    end


    desc "Delete a technology."
    params do
      requires :id, type: String, desc: "Technology ID."
    end

    delete ':id' do
      @technology = Technology.find(params[:id])
      @technology.destroy
    end

  end

end
