class API::V1::DescTags < Grape::API
  include API::V1::Helpers

  before do
    authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(
        params[:desc_tag]
      ).permit(:photo_desc_id, names: [], category_ids: [])
    end
  end

  resource :desc_tags do

    desc 'create new desc'
    params do
      # requires :status, type: String, desc: "Your status."
    end
    post '/', rabl: 'desc_tags/show' do
      @tag = DescTag.create!(permitted_params)
    end

    
    desc 'update a desc'
    params do
      requires :id, type: Integer, desc: "desc id"
    end
    put ':id', rabl: 'desc_tags/show' do
      @tag = DescTag.find(params[:desc_tag][:id])
      @tag.update_attributes!(permitted_params)
    end

    # desc "return photo descs"
    # get '/', rabl: 'photo_descs/index' do
    #   @descs = PhotoDesc.where(dtype: params[:dtype]||0).order("id desc")
    #   @count = @descs.count
    #   if params[:q].present?
    #     @descs = @descs.where("tags like ?", "%#{params[:q]}%")
    #   end
    #   @descs = @descs.page(params)
    # end

    desc "Delete a Desc tag."
    params do
      requires :id, type: String, desc: "Desc ID."
    end

    delete ':id' do
      @tag = DescTag.find(params[:id])
      @tag.destroy
    end

  end

end
