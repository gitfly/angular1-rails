class API::V1::Appointments < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:appointment]).permit(
        :id, :customer_id, :date, :trouble, :trouble_desc, :trouble_type, :atype,
        :finished, :name, :phone, :cancel, :cancel_reason, :cancel_type, :date_detail_start,
        :date_detail_end, :weixin
      )
    end
  end

  resource :appointments do

    get '/list', rabl: 'appointments/list' do
      @appointments = Appointment.
        send(params[:type]||:all).
        send(params[:status]||:all).
        includes(:addresses).
        order('id desc').limit(120)
    end

    desc "fetch with trouble"
    put '/:id/fecth_trouble'do
      @appointment = Appointment.find(params[:id])
      @appointment.update!(
        trouble:true,
        trouble_type: Appointment::TroubleType[params[:trouble_type].to_sym],
        trouble_desc: params[:trouble_desc],
        finished: true
      )
      return {value:true}
    end

    desc "select appointment info by id"
    get '/:id', rabl: 'appointments/show' do
      @appointment = Appointment.find(params[:id])
    end

		desc "update appointment"
		put "/:id", rabl: 'appointments/show_list' do
      @appointment = Appointment.find(params[:id])
			@appointment.update_with_asso(params[:appointment])
		end

    desc "cancle appointment" 
    put "/:id/cancel" do
      @appointment = Appointment.find(params[:id])
			@appointment.update!(
				Appointment.permit(params[:appointment]).merge(cancel: true)
			)
    end

    put "/:id/finish", rabl:'appointments/show' do
      @appointment = Appointment.find(params[:id])
      @appointment.update_attributes!(finished: true)
    end

    get '/', rabl: 'appointments/index' do
      @appointments = Appointment.where(
        trouble: params[:trouble],
        finished: params[:finished],
        atype: params[:atype]
      )
      search_date = params[:date] || Time.zone.now.strftime("%Y-%m-%d")
      @appointments = @appointments.where("date(appointments.date) = date(#{search_date})") 
      @all_count = @appointments.count
      @finished_count = @appointments.finished.count
      @unfinished_count = @appointments.unfinished.count
      @door_count = @appointments.door_type.count
      @express_count =  @appointments.express_type.count
      @cancel_count = @appointments.cancel.count   
    end

    post '/', rabl:'appointments/show' do
      customer = Customer.where(
        phone: params[:appointment][:phone]
      ).first_or_create(name: params[:appointment][:name])
      @appointment = Appointment.create!(permitted_params.merge(customer_id: customer.id))
    end
  end

end
