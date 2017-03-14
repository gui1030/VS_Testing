class ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      case user
      when Admin
        scope.all
      when AccountUser
        scope.eager_load(:unit).where(units: { id: user.units })
      when UnitUser
        scope.eager_load(:unit).where(units: { id: user.unit })
      end
    end
  end

  attr_accessor :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def index?
    true
  end

  def new?
    create?
  end

  def create?
    default_write
  end

  def show?
    default_read
  end

  def edit?
    update?
  end

  def update?
    default_write
  end

  def destroy?
    default_write
  end

  protected

  def default_read
    user.reads? model
  end

  def default_write
    user.writes? model
  end
end
