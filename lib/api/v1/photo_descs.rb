class API::V1::PhotoDescs < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all
  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(
        params[:photo_desc]
      ).permit(:content, :symptom, :technology, :expect, :dtype, tags: [], category_ids: [])
    end
  end

  resource :photo_descs do

    desc 'create new desc'
    params do
      # requires :status, type: String, desc: "Your status."
    end
    post '/', rabl: 'photo_descs/show' do
      @desc = PhotoDesc.create!(permitted_params)
    end
    
    desc 'update a desc'
    params do
      requires :id, type: Integer, desc: "desc id"
    end
    put ':id', rabl: 'photo_descs/show' do
      @desc = PhotoDesc.find(params[:photo_desc][:id])
      @desc.update_attributes!(permitted_params)
      @desc.reload
    end

    desc "return photo descs"
    get '/', rabl: 'photo_descs/index' do
      @descs = PhotoDesc.where(dtype: params[:dtype]||0).order("id desc")
      @count = @descs.count
      if params[:q].present?
        @descs = @descs.where("content like ?", "%#{params[:q]}%")
      end
      @descs = @descs.page(params)
    end

    desc "Delete a Desc."
    params do
      requires :id, type: String, desc: "Desc ID."
    end

    delete ':id' do
      @desc = PhotoDesc.find(params[:id])
      @desc.destroy
    end

  end

end
