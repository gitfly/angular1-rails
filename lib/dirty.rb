class ActiveRecord::Base
  # params={per_page: 20, page: 1}
  # page start from 1
  def self.page(params={})
    per_page = (params[:per_page] || 20).to_i
    offset = (params[:page].to_i-1) * per_page
    offset < 0 and offset = 0
    self.offset(offset).limit(per_page)
  end

  def param_name
    self.class.param_name
  end

  def self.param_name
    self.name.underscore
  end

  def self.permitted_attributes
    Settings.permitted_attributes.send(param_name)
  end

  def self.permit(params)
    ActionController::Parameters.new(params).permit(
      permitted_attributes
    )
  end

  def self.permit_by(params, name=nil, parent=nil)
    name ||= param_name
    params = params[parent][name] if parent

    ActionController::Parameters.new(
      params[name]
    ).permit(permitted_attributes)
  end
end

