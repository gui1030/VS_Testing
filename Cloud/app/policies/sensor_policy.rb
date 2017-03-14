class SensorPolicy < RestrictedPolicy
  def index?
    super || user.is_a?(AccountUser)
  end

  def update?
    model.location_type.nil? && super
  end

  def destroy?
    model.location_type.nil? && super
  end

  def permitted_attributes
    attributes = [:name]
    attributes << :mac if user.is_a? Admin
    attributes
  end
end
