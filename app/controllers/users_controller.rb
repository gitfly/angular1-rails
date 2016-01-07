class UsersController < ApplicationController
  load_and_authorize_resource
  include Roar::Rails::ControllerAdditions
  represents :json, User

  def edit
  end

  def show
    # respond_with @user
  end
end
