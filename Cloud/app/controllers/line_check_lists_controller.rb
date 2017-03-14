class LineCheckListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_unit, only: [:index, :new, :create]
  before_action :set_line_check_list, except: [:index, :new, :create]
  before_action :deconvert_units, only: [:create, :update]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @line_check_lists = policy_scope(@unit.line_check_lists)
  end

  def new
    @line_check_list = @unit.line_check_lists.new
    @line_check_list.items.build
    @line_check_list.schedules.build
    authorize @line_check_list
  end

  def create
    @line_check_list = @unit.line_check_lists.new(line_check_list_params)
    authorize @line_check_list
    if @line_check_list.save
      redirect_to unit_veritemp_line_check_lists_path(@unit), notice: 'Line Check List Created'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @line_check_list.update(line_check_list_params)
      redirect_to unit_veritemp_line_check_lists_path(@unit), notice: 'Line Check List Updated'
    else
      render :edit
    end
  end

  def destroy
    @line_check_list.destroy
    redirect_to unit_veritemp_line_check_lists_path(@unit), notice: 'Line Check List Deleted'
  end

  private

  def set_unit
    @unit = Unit.find(params[:unit_id])
  end

  def set_line_check_list
    @line_check_list = LineCheckList.find(params[:id])
    authorize @line_check_list
    @unit = @line_check_list.unit
  end

  def line_check_list_params
    params.require(:line_check_list)
          .permit(:name,
                  line_check_items_attributes: [
                    :id,
                    :_destroy,
                    :name,
                    :temp_low,
                    :temp_high,
                    :description
                  ],
                  line_check_schedules_attributes: [
                    :id,
                    :_destroy,
                    :time
                  ])
  end

  def deconvert_units
    params[:line_check_list][:line_check_items_attributes].transform_values! do |item_params|
      item_params.merge(
        temp_low: @temp_converter.deconvert(item_params[:temp_low].to_f).to_s,
        temp_high: @temp_converter.deconvert(item_params[:temp_high].to_f).to_s
      )
    end
  end
end
