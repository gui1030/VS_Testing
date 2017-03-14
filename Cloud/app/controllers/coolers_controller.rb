class CoolersController < ApplicationController
  include TempsHelper
  before_action :set_unit, only: [:index, :new, :create]
  before_action :set_cooler, except: [:index, :new, :create]
  before_action :deconvert_units, only: [:create, :update]

  def index
    @auth_stub = @unit.coolers.new
    authorize @auth_stub
    @coolers = @unit.coolers.reload
  end

  def new
    self.referer = request.referer
    @cooler = @unit.coolers.new
    authorize @cooler
  end

  def create
    @cooler = @unit.coolers.new(cooler_params)
    authorize @cooler

    if @cooler.save
      redirect_to referer, notice: "Created Cooler: #{@cooler}"
    else
      flash.now[:alert] = @cooler.errors.full_messages.first
      render :new
    end
  end

  def edit
    self.referer = request.referer
  end

  def update
    if @cooler.update_attributes(cooler_params)
      redirect_to referer, notice: 'Cooler updated'
    else
      flash.now[:alert] = @cooler.errors.full_messages.first
      render :edit
    end
  end

  def destroy
    if @cooler.destroy
      redirect_to :back, notice: 'Cooler deleted'
    else
      redirect_to :back, alert: @cooler.errors.full_messages[0]
    end
  end

  private

  def set_unit
    @unit = Unit.find(params[:unit_id])
  end

  def set_cooler
    @cooler = Cooler.find(params[:id])
    authorize @cooler
    @unit = @cooler.unit
  end

  def cooler_params
    params.require(:cooler).permit(policy(Cooler).permitted_attributes)
  end

  def deconvert_units
    cooler = params[:cooler]
    [:top_temp_threshold, :bottom_temp_threshold].each do |thresh|
      cooler[thresh] = @temp_converter.deconvert(cooler[thresh].to_f).to_s
    end
  end
end
