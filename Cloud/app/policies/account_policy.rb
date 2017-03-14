class AccountPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case user
      when Admin then scope.all
      when AccountUser then scope.where(id: user.account_id)
      else scope.none
      end
    end
  end

  def index?
    user.is_a? Admin
  end

  def create?
    user.is_a? Admin
  end

  def confirm?
    user.is_a?(AccountUser)
  end

  def permitted_attributes
    [
      :name,
      :logo,
      :address,
      :address1,
      :city,
      :state,
      :zipcode
    ]
  end
end
