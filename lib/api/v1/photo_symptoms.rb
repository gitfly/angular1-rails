class API::V1::PhotoSymptoms < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all
  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:photo_symptom]).permit(
        :photo_id, :effect, :desc, :stype, category_ids: [], symptoms: []
      )
    end
  end

  resource :photo_symptoms do

    desc 'create new symptoms'
    params do
      # requires :status, type: String, desc: "Your status."
    end
    post '/', rabl: 'photo_symptoms/show' do
      @photo = Photo.find(permitted_params[:photo_id])
      @symptom = @photo.symptoms.create!(permitted_params)
      @category = Category.find(@symptom.category_ids.last)
    end
    
    desc 'update a symptoms'
    params do
      # requires :id, type: Integer, desc: "symptoms id"
      # requires :photo_id, type: Integer, desc: "photo id"
    end

    put ':id', rabl: 'photo_symptoms/show' do
      @photo = Photo.find(permitted_params[:photo_id])
      @symptom = @photo.symptoms.find(params[:photo_symptom][:id])

      tags = permitted_params[:symptoms].join(',')

      ids = DescTag.where(names: tags).pluck(:photo_desc_id)

      dtype = @symptom.stype ? 3 : 0

      content = PhotoDesc.where(id: ids, dtype: dtype).first.try(:content)
      @symptom.update_attributes!(permitted_params.merge(desc: content))

      @category = Category.find(@symptom.category_ids.last)

      # sids = Service.where(name: @symptom.symptoms.last).pluck(:id)
      # if sids.present?
      #   order = @symptom.order
      #   ids = order.service_ids.try(:split, ',')
      #   ids += sids
      #   ids.uniq!
      #   price = Service.where(id: ids).pluck(:price).sum
      #   order.update_attributes!(service_ids: ids.join(','), price: price)
      # end
    end

    # desc "return photos of an order"
    # get '/', rabl: 'photos/index' do
    #   @order = Order.find(params[:order_id])
    #   @photos = @order.photos.includes(:symptoms)
    # end

    desc "Delete a photo symptom"
    params do
      requires :id, type: String, desc: "Photo ID."
    end

    delete ':id' do
      @symptom = PhotoSymptom.find(params[:id])
      @symptom.destroy
    end

  end

end
