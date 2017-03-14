class ReportsController < ApplicationController
  before_action :set_unit

  def new
  end

  def create
    Time.use_zone(current_user.time_zone) do
      @coolers = @unit.coolers.where(id: params[:unit][:cooler_ids])
      start_time = Time.strptime(params[:start_time], '%m/%d/%Y').in_time_zone.utc.beginning_of_day + 5.hours
      end_time = Time.strptime(params[:end_time], '%m/%d/%Y').in_time_zone.utc.end_of_day + 5.hours
      if end_time >= start_time
        @range = start_time..end_time
        name = params[:name].present? ? params[:name] : 'report'
        render xlsx: name, template: 'reports/show'
      else
        redirect_to :back, notice: 'End date cannot be before the start date'
      end
    end
  end
  private

  def set_unit
    @unit = Unit.find(params[:unit_id])
    authorize @unit, :show?
  end
end
