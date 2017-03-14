class OrderPolicy < ApplicationPolicy
  def index?
    user.is_a? Admin
  end

  def open?
    fulfillment?
  end

  def fulfillment?
    default_write
  end

  def track?
    index? && user.reads?(model)
  end

  protected

  def default_read
    user.is_a? Admin
  end

  def default_write
    user.is_a? Admin
  end
end
