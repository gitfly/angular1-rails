class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:solutionist]
  before_action :set_order, only: [:show, :edit, :update, :destroy, :solutionist, :effect_result]

  respond_to :html

  def index
    @orders = Order.all
    respond_with(@orders)
  end

  def show
    @order = Order.first
    respond_with(@order)
  end

  def new
    @order = Order.new
    respond_with(@order)
  end

  def edit
  end

  def solutionist
    @customer = @order.customer
    @item = @order.item
    @photos = @order.photos.used.includes(:symptoms)
    @template = @order.before_template
    render :layout => 'slim'
  end

  def effect_result
    @customer = @order.customer
    @item = @order.item
    @photos = @order.photos.used.includes(:symptoms)
    @template = @order.after_template
    render :layout => 'slim'
  end

  def create
    @order = Order.new(order_params)
    @order.save
    respond_with(@order)
  end

  def update
    @order.update(order_params)
    respond_with(@order)
  end

  def destroy
    @order.destroy
    respond_with(@order)
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params[:order]
    end
end
