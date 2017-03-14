class OrdersController < ApplicationController
  before_action :set_order, except: [:index, :open]

  def index
    authorize Order
    @unit = Unit.find params[:unit_id]
    authorize @unit, :show?
    @orders = @unit.orders.order(created_at: :desc)
  end

  def open
    authorize Order
    @incomplete_orders = Order.unfulfilled.claimed_by(current_user).order(fulfillment_started_at: :asc)
    @unclaimed_orders = Order.unfulfilled.unclaimed.order(created_at: :asc)
  end

  def destroy
    if @order.destroy
      redirect_to :back, notice: 'Order Deleted'
    else
      redirect_to :back, alert: @order.errors.full_messages.first
    end
  end

  def track
    ups = ActiveShipping::UPS.new(
      login: Figaro.env.ups_login,
      password: Figaro.env.ups_password,
      key: Figaro.env.ups_key,
      origin_account: Figaro.env.ups_account,
      test: Figaro.env.test_shipping
    )
    @tracking_info = ups.find_tracking_info(@order.tracking_number)
  end

  private

  def set_order
    @order = Order.find params[:id]
    authorize @order
    @unit = @order.unit
  end
end
