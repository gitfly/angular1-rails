class API::V1::Descs < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(
        params[:photo_desc]
      ).permit(:content, tags: [], category_ids: [])
    end
  end

  resource :descs do

    desc "return descs"
    get '/', rabl: 'photo_descs/index' do
      @descs = PhotoDesc.where(tags: params[:tags]).group('dtype').order('dtype')
    end

  end

end
