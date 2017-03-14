class AccountUserPolicy < UserPolicy
  class Scope < Scope
    def resolve
      case user
      when Admin then scope.all
      when AccountUser then scope.where(account: user.account)
      else scope.none
      end
    end
  end

  def index?
    super || user.is_a?(AccountUser)
  end

  def account_admin?
    user != model && (user.is_a?(Admin) || (user.is_a?(AccountUser) && user.account_admin?))
  end

  def permissions?
    user != model && default_write
  end

  def permitted_attributes
    attributes = super
    attributes << :account_admin if account_admin?
    attributes << { unit_ids: [] } if permissions?
    attributes
  end

  protected

  def default_read
    default_write
  end

  def default_write
    case user
    when Admin, model
      true
    when AccountUser
      user.account_admin? || subset?
    else
      false
    end
  end

  def subset?
    (user.units - model.units).present? && (model.units - user.units).empty?
  end
end
