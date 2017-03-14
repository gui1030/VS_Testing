class UnitsController < ApplicationController
  before_action :set_account, only: [:index, :new, :create]
  before_action :set_unit, except: [:index, :new, :create]
  before_action :convert_units, only: [:create, :update]

  def index
    authorize @account, :show?
    authorize Unit
    @units = policy_scope(@account.units)
  end

  def new
    self.referer = request.referer
    @unit = @account.units.new
    authorize @unit
  end

  def create
    @unit = @account.units.new(unit_params)
    authorize @unit

    if @unit.save
      redirect_to referer, notice: 'Unit created'
    else
      render :new
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { chart }
    end
  end

  def edit
    self.referer = request.referer
  end

  def update
    if @unit.update(unit_params)
      redirect_to referer, notice: 'Unit updated'
    else
      render :edit
    end
  end

  def destroy
    if @unit.destroy
      redirect_to :back, notice: "Deleted unit: #{@unit}"
    else
      redirect_to :back, alert: @unit.errors.full_messages.first
    end
  end

  private

  def set_account
    @account = Account.find params[:account_id]
  end

  def set_unit
    @unit = Unit.find params[:id]
    authorize @unit
  end

  def unit_params
    params.require(:unit).permit(policy(Unit).permitted_attributes)
  end

  def convert_units
    params[:unit][:notify_threshold] = @temp_converter.descale(params[:unit][:notify_threshold].to_f).to_s
  end

  def chart
    range = Time.current.all_range(params[:range])
    readings = @unit.readings.where(reading_time: range)
    groups = case params[:range].to_sym
             when :day then readings.group_by_hour(:reading_time, format: '%-l%p')
             when :week, :month then readings.group_by_day(:reading_time, format: '%a %-m-%-e')
             when :year then readings.group_by_month(:reading_time, format: '%-b')
             end
    compliance = groups.average(:success)
    render json: { label: 'Compliance (%)', labels: compliance.keys, data: compliance.values.map { |val| val * 100 }, type: :category }
  end
end
