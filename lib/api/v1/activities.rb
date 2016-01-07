class API::V1::Activities < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:activity]).permit(
        :name, :discount_manner, :amount, :content, :consume_add_up,
        :start_date, :end_date, :atype, :addup, :real_income, :original_price, 
        :item_type => []
      ).tap do |hash|
        hash[:item_type] = hash[:item_type].join(',') if hash[:item_type]
      end
    end
  end

  resource :activities do

    get '/', rabl: 'activities/index' do
      @activities = Activity.
        send(params[:type]||:all).
        order('atype asc').
        where("atype in (0, 1, 3)")
    end

    put '/apply_to_orders/:activity_id' do
      @activity = Activity.where(id: params[:activity_id]).first
      @orders = @activity.apply_to(
        params[:activity].merge(handler_id: current_user.id)
      )
      true
    end

    put '/clear_activity' do
      @orders = Order.where(id: params[:activity][:order_ids])
      @orders.map{|o| o.use_activity_by(current_user.id, nil)}
      true
    end

    desc 'create new activity'
    params do
      # requires :status, type: String, desc: "Your status."
    end
    post '/', rabl: 'activities/create' do
      @activity = Activity.create!(permitted_params)

      if params[:activity][:order_ids]
        @orders = Order.where(id: params[:activity][:order_ids])
        @orders.map{|o| o.use_activity_by(current_user.id, @activity.id)}
      end

      @activity
    end

    desc "Update an Activity."
    params do
      requires :id, type: String, desc: "Activity ID."
    end
    put ':id', rabl: 'activities/show' do
      @activity = Activity.find(params[:activity][:id])
      @activity.update_attributes!(permitted_params)
    end

    desc "Delete an Activity."
    params do
      requires :id, type: String, desc: "Activity ID."
    end

    delete ':id' do
      @activity = Activity.find(params[:id])
      @activity.destroy
    end
  end

end
