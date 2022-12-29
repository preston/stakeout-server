class DashboardsController < ApplicationController
  before_action :set_dashboard, only: [:show, :edit, :update, :destroy]

  # before_action :ensure_active_dashboard_is_set, only: [:index]

  # GET /dashboards
  # GET /dashboards.json
  def index
    @dashboards = Dashboard.all
  end

  def check
    period = params[:client_period].to_i
    @since = period.minutes.ago
    d = Dashboard.find(session[:active_dashboard_id])
    d.services.each do |s|
      s.check
    end
    respond_to do |format|
      format.html { render 'services/index', layout: false }
    end
  end

  def active
    d = Dashboard.find(params[:id])
    set_as_active_dashboard d
    format.json { render json: d }
  end

  # GET /services/1
  # GET /services/1.json
  def show
    # render :show
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
    render partial: 'dashboards/edit'
  end

  # POST /dashboards
  # POST /dashboards.json
  def create
    @dashboard = Dashboard.new(dashboard_params)
    if @dashboard.save
      render json: @dashboard, status: :created, location: @dashboard
    else
      render json: @dashboard.errors, status: :unprocessable_entity
    end
  end

  def update

      if @dashboard.update(dashboard_params)
       
         render json: @dashboard 
      else
    render json: @dashboard.errors, status: :unprocessable_entity 
    
    end
  end

  # DELETE /dashboards/1
  # DELETE /dashboards/1.json
  def destroy
    @dashboard.destroy
    set_an_active_dashboard
      render	json: @active_dashboard
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dashboard
    @dashboard = Dashboard.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dashboard_params
    params.require(:dashboard).permit(:name)
  end
end
