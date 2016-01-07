class API::V1::SoluTemplates < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(
        params[:solu_template]
      ).permit(:header, :footer, :before)
    end
  end

  resource :solu_templates do

    desc 'create new solutemplate'
    params do
      # requires :status, type: String, desc: "Your status."
    end

    post '/', rabl: 'solu_templates/show' do
      @template = SoluTemplate.create!(permitted_params)
    end

    desc "get solu templates list"
    get '/', rabl: 'solu_templates/index' do
      @templates = SoluTemplate.where(before: params[:before]).order('id desc').includes(:photos)
    end

    desc "Update a template."
    params do
      requires :id, type: String, desc: "Template ID."
      # requires :status, type: String, desc: "Your status."
    end
    put ':id', rabl: 'solu_templates/show' do
      @template = SoluTemplate.find(params[:solu_template][:id])
      @template.update_attributes!(permitted_params)
    end

    desc "Delete a template."
    params do
      requires :id, type: String, desc: "Template ID."
    end

    delete ':id' do
      @template = SoluTemplate.find(params[:id])
      @template.destroy
    end

  end

end
