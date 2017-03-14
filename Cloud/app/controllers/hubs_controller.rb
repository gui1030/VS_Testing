class HubsController < ApplicationController
  before_action :set_unit, only: [:index, :new, :create]
  before_action :set_hub, except: [:index, :new, :create]

  def index
    authorize @unit, :show?
    authorize Hub
    @hubs = @unit.hubs
  end

  def new
    hub_name = "#{@unit} Hub"
    @hub = @unit.hubs.new(name: hub_name)
    authorize @hub
  end

  def create
    @hub = @unit.hubs.new(hub_params)
    authorize @hub

    if @hub.save
      redirect_to unit_hubs_path(@unit), notice: 'Hub ' + @hub.name + ' created'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @hub.update_attributes(hub_params)
      redirect_to unit_hubs_path(@unit), notice: 'Hub updated'
    else
      render :edit
    end
  end

  def destroy
    if @hub.destroy
      redirect_to :back, notice: 'Deleted hub ' + @hub.name
    else
      redirect_to :back, alert: @hub.errors.full_messages[0]
    end
  end

  #### DEVICE REMOTE COMMANDS ####
  def restart
    if @hub.restart
      redirect_to :back, notice: 'Hub Restarted'
    else
      redirect_to :back, alert: @hub.errors.full_messages.first
    end
  end

  # Device Variables

  def status
    render layout: false
  end

  private

  def set_unit
    @unit = Unit.find(params[:unit_id])
  end

  def set_hub
    @hub = Hub.find(params[:id])
    authorize @hub
    @unit = @hub.unit
  end

  def hub_params
    params.require(:hub).permit(policy(Hub).permitted_attributes)
  end
end
