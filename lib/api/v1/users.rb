class API::V1::Users < Grape::API
  include API::V1::Helpers

  doorkeeper_for :all

  before do
    # authenticate!
  end

  helpers do
    def permitted_params
      ActionController::Parameters.new(params[:user]).permit(
        :name, :email, :weixin, :phone, 
        :birthday, :gender, :type, :password, :password_confirmation
      )
    end
    def current_token; env['api.token']; end

    def current_resource_owner
      User.find(current_token.resource_owner_id) if current_token
    end

    def warden; env['warden']; end
  end

  resource :users do

    get '/', rabl: 'users/index' do
      @users = User.us.order(:name)
    end 

    desc 'Return current user, requires authentication'
    get 'me', rabl: 'users/show' do
      @user = current_resource_owner
    end

    desc "Return all users' emails, doesn't require authentication"
    get '/', protected: false do
      User.all.pluck(:email)
    end

    desc 'return a user'  #, auth: { scopes: ['public'] }

    params { requires :id, type: Integer, desc: "User id" }

    route_param :id do
      get '/', rabl: 'users/show' do
        @user = User.find(params[:id])
      end
    end

    desc 'Logout user'
    delete 'logout' do
      warden.logout
    end

    post '/', rabl: 'users/show' do
      @user = User.create!(permitted_params)
    end

    desc "update an user"
    route_param :id do
      put '/' do
        @user = User.find(params[:user][:id])
        @user.update_attributes!(permitted_params)
      end
    end

    desc "Delete an user."
    params do
      requires :id, type: String, desc: "Order ID."
    end
    delete ':id' do
      @user = User.find(params[:id])
      @user.destroy
    end

  end

end
