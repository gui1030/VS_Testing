class SensorsController < ApplicationController
  before_action :set_unit, only: [:index, :new, :create]
  before_action :set_sensor, except: [:index, :new, :create]

  def index
    authorize @unit, :show?
    authorize Sensor
    @sensors = @unit.sensors.where(location_type: [nil, 'Cooler'])
  end

  def new
    @sensor = @unit.sensors.new
    authorize @sensor
  end

  def create
    @sensor = @unit.sensors.new(sensor_params)
    authorize @sensor

    if @sensor.save
      redirect_to unit_sensors_path(@unit), notice: 'Sensor "' + @sensor.name + '" created'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @sensor.update_attributes(sensor_params)
      redirect_to unit_sensors_path(@unit), notice: 'Sensor updated'
    else
      render :edit
    end
  end

  def destroy
    if @sensor.destroy
      redirect_to :back, notice: "Deleted Sensor: #{@sensor}"
    else
      redirect_to :back, alert: @sensor.errors.full_messages[0]
    end
  end

  private

  def set_unit
    @unit = Unit.find params[:unit_id]
  end

  def set_sensor
    @sensor = Sensor.find params[:id]
    authorize @sensor
    @unit = @sensor.unit
  end

  def sensor_params
    params.require(:sensor).permit(policy(Sensor).permitted_attributes)
  end
end
