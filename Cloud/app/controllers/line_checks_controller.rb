class LineChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_line_check, except: [:index, :new, :create]
  after_action :verify_authorized, except: :index

  def show
  end

  private

  def set_line_check
    @line_check = LineCheck.find(params[:id])
    authorize @line_check
  end
end
