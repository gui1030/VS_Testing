class UnitPolicy < RestrictedPolicy
  class Scope < Scope
    def resolve
      if user.is_a? Admin
        scope.all
      elsif user.is_a? AccountUser
        scope.where(id: user.units)
      elsif user.is_a? UnitUser
        scope.where(id: user.unit_id)
      else
        scope.none
      end
    end
  end

  def network?
    user.is_a? Admin
  end

  def permitted_attributes
    attributes = [
      :name,
      :logo,
      :address,
      :address1,
      :city,
      :state,
      :zipcode,
      :recurring_notify_duration,
      :notify_threshold,
      :humidity_notify_threshold,
      :humidity_recurring_notify_duration
    ]
    attributes << :probe_enabled if user.is_a? Admin
    attributes
  end
end
