class AppointmentsController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  respond_to :html, :mobile, :json

  def index
    @appointments = Appointment.all
    respond_with(@appointments)
  end

  def welcome
    # Thread.new do
    # end
    if params[:code]
      @token = WechatToken.get_token_by_code(params[:code])
      weixin = @token.weixin_account
      weixin.get_user_info

      if weixin && weixin.user && weixin.user.appointments.unfinished.exists?
        redirect_to weixin.user.appointments.unfinished.last
      end
    end
  end

  def show
    @customer = @appointment.customer
    @code = @appointment.customer.weixin_account.try(:code)
    @obj = @appointment.association_obj
    respond_with(@appointment)
  end

  def new
    @address = Address.new
    @express = Express.new
    @customer = Customer.new
    @appointment = Appointment.new
    respond_with(@appointment)
  end

  def edit
    @customer = @appointment.customer
    @address = @appointment.address
    @express = @appointment.express
  end

  def create
    @customer, @appointment, @obj = 
      Appointment.create_with_asso(params[:appointment])
    render 'show'
  end

  def update
    @customer, @obj = 
      @appointment.update_with_asso(params[:appointment])
    render 'show'
  end

  def destroy
    @appointment.destroy
    respond_with(@appointment)
  end

  private
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def address_params
      params[:appointment].require(:address).permit(:province, :city, :district, :details)
    end

    def customer_params
      params[:appointment].require(:customer).permit(:name, :phone, :email, :weixin, :avatar)
    end

    def appointment_params
      params.require(:appointment).permit(:customer_id, :date, :customer, :address)
    end

end
