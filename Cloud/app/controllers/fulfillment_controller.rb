class FulfillmentController < ApplicationController
  include Wicked::Wizard

  before_action :set_order
  before_action :claim_order
  before_action :set_steps
  before_action :setup_wizard
  before_action :set_line_item

  def show
    render_wizard
  end

  def update
    render_wizard case step
                  when /line_item_\d+/
                    update_line_item
                  when :shipping
                    @order.assign_attributes(order_params)
                    @order.fulfilled_at = Time.current
                    @order
                  end
  end

  def render_step(the_step, options = {})
    case the_step
    when /line_item_\d+/
      render :line_item, options
    else
      super
    end
  end

  def finish_wizard_path
    open_orders_path
  end

  private

  def set_order
    @order = Order.find params[:order_id]
    authorize @order
  end

  def set_steps
    self.steps = @order.line_items.map { |item| :"line_item_#{item.id}" }
    steps << :shipping
  end

  def set_line_item
    case step
    when /line_item_(\d+)/
      @line_item = LineItem.find Regexp.last_match(1)
    end
  end

  def update_line_item
    location = @line_item.sensor.location
    case location
    when Hub
      location.assign_attributes(hub_attributes)
      location
    else
      @line_item.sensor.assign_attributes(sensor_attributes)
      @line_item.sensor
    end
  end

  def order_params
    params.require(:order).permit(:tracking_number)
  end

  def hub_attributes
    params.require(:hub).permit(policy(Hub).permitted_attributes)
  end

  def sensor_attributes
    params.require(:sensor).permit(policy(Sensor).permitted_attributes)
  end

  def claim_order
    if @order.claimed_by?(current_user)
      true
    elsif @order.unclaimed?
      @order.update fulfillment_started_at: Time.current, fulfilled_by: current_user
    else
      redirect_to open_orders_path, alert: 'This order is already being processed by someone else'
    end
  end
end
