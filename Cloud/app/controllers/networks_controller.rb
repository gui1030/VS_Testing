class NetworksController < ApplicationController
  def show
    @unit = Unit.find(params[:unit_id])
    authorize @unit, :network?
    respond_to do |format|
      format.html
      format.json { render json: SensorGraph.new(@unit).to_json }
    end
  end
end
