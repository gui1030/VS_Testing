class UnitUserPolicy < UserPolicy
  class Scope < Scope
    def resolve
      case user
      when Admin then scope.all
      when AccountUser
        scope.where(unit: user.units)
      when UnitUser
        scope.where(id: user.id)
      else scope.none
      end
    end
  end

  def index?
    super || user.is_a?(AccountUser)
  end
end
