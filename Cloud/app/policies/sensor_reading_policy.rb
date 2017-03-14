class SensorReadingPolicy < ApplicationPolicy
  def default_write
    false
  end
end
