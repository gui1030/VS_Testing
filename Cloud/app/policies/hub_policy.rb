class HubPolicy < RestrictedPolicy
  def restart?
    model.registered? && user.is_a?(Admin)
  end

  def status?
    show?
  end

  def permitted_attributes
    attributes = [:name]
    attributes << :particle_id if user.is_a? Admin
    attributes
  end
end
