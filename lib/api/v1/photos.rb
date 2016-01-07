class API::V1::Photos < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:photo]).permit(
        :photo, :parent_id, :photoable_id, :photoable_type, :header, :sequence, :used, :front
      )
    end
  end

  resource :photos do

    # get '/', rabl: 'addresses/index' do
    #   @customer = Customer.find(params[:customer_id])
    #   @addresses = @customer.addresses
    # end

    desc 'create new photo'
    params do
      # requires :status, type: String, desc: "Your status."
    end
    post '/', rabl: 'photos/show' do
      ap params if Rails.env.development?
      @photo = Photo.new(permitted_params)
      if params[:photo][:photo]
        @photo.processors = [:watermark] if @photo.photoable_type == "Order" && !params[:no_watermark]
        @photo.photo = params[:photo][:photo][:tempfile]
      end
      @photo.save!
    end

    desc "return photos of an order"
    get '/', rabl: 'photos/index' do
      
      @order = Order.find(params[:order_id]) if params[:order_id]
      @order = Order.find_by_number(params[:order_number]) if params[:order_number]

      @with_child = params[:with_child] == 'true'
      if @with_child
        @photos = @order.photos.all_parents.includes(:child_photos).includes(:symptoms)
      else
        @photos = @order.photos.includes(:symptoms).all_parents
      end
      @photos = @photos.used if params[:used]
      @photos = @photos.order("sequence asc")
      @stype = params[:stype] == 'true'
    end

    route_param :id do
      put '/', rabl: 'photos/show' do
        @photo = Photo.unscoped.find(params[:photo][:id])
        if params[:photo][:photo]
          @photo.processors = [:watermark] if @photo.photoable_type == "Order" && !params[:photo][:photo][:no_watermark]
          @photo.photo = params[:photo][:photo][:tempfile]
          @photo.photo_file_name = params[:photo][:photo][:filename]
        end
        @photo.update_attributes!(permitted_params)
      end
    end

    desc "Delete a photo."
    params do
      requires :id, type: String, desc: "Photo ID."
    end

    delete ':id' do
      @photo = Photo.where(id: eval(params[:id]))
      @photo.destroy_all
    end

  end

end
