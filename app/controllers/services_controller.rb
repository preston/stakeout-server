class ServicesController < ApplicationController
  before_action :set_service, only: %i[show edit update destroy]

  # GET /services
  # GET /services.json
  def index
    period = 0
    period = params[:period].to_i unless params[:period].nil?
    @dashboard = Dashboard.find(params[:dashboard_id])
    @services = @dashboard.services
    since = Time.now - period
    @services.each do |s|
      s.check_if_older_than(since)
    end
    render layout: false
  end

  # GET /services/1
  # GET /services/1.json
  def show; end

  # GET /services/new
  def new
    @dashboard = Dashboard.find(params[:dashboard_id])
    @service = Service.new
    @service.dashboard = @dashboard
    render partial: 'services/new'
  end

  # GET /services/1/edit
  def edit
    render partial: 'services/edit'
  end

  # POST
  def create
    @service = Service.new(service_params)

    if @service.save
      render json: @service, status: :created, location: @service
    else
      render json: @service.errors, status: :unprocessable_entity
    end
  end

  # PUT
  def update
    if @service.update(service_params)
      @service.expire_check
      head :no_content
    else
      render json: @service.errors, status: :unprocessable_entity
    end
  end

  # DELETE
  def destroy
    @service.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(:name, :dashboard_id, :host, :ping, :ping_threshold, :http, :https,
                                    :http_preview, :http_path, :http_xquery)
  end
end
