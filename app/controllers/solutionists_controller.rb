class SolutionistsController < ApplicationController
  before_action :set_solutionist, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @solutionists = Solutionist.all
    respond_with(@solutionists)
  end

  def show
    respond_with(@solutionist)
  end

  def new
    @solutionist = Solutionist.new
    respond_with(@solutionist)
  end

  def edit
  end

  def create
    @solutionist = Solutionist.new(solutionist_params)
    @solutionist.save
    respond_with(@solutionist)
  end

  def update
    @solutionist.update(solutionist_params)
    respond_with(@solutionist)
  end

  def destroy
    @solutionist.destroy
    respond_with(@solutionist)
  end

  private
    def set_solutionist
      @solutionist = Solutionist.find(params[:id])
    end

    def solutionist_params
      params[:solutionist]
    end
end
