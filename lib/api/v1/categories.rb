class API::V1::Categories < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:category]).permit(:name, :parent_id)
    end
  end

  resource :categories do

    desc 'return a Category and its children'
    # params { requires :id, type: Integer, desc: "User id" }

    route_param :name do
      get '/', rabl: 'categories/show' do
        # @category = Category.where(name: )
      end
    end


    desc 'create new Category'
    params do
      # requires :status, type: String, desc: "Your status."
    end
    post '/', rabl: 'categories/show' do
      # @parent = Category.find_by_id(permitted_params[:parent_id])
      @category = Category.create!(permitted_params)
    end


    desc 'return categories'
    get '/', rabl: "categories/index" do
      @category = Category.where(id: params[:category_id]).first
      @categories = if @category
                      @category.children.includes(:children)
                    else
                      Category.roots
                    end
    end


    desc "Update a Category."
    params do
      requires :id, type: String, desc: "Category ID."
      # requires :status, type: String, desc: "Your status."
    end
    put ':id', rabl: 'categories/show' do
      # binding.pry
      @category = Category.find(params[:category][:id])
      @category.update_attributes!(permitted_params)
    end


    desc "Delete a Category."
    params do
      # requires :id, type: String, desc: "Category ID."
    end

    delete ':id' do
      @category = Category.where(id: eval(params[:id]))
      @category.destroy_all
    end

  end

end
