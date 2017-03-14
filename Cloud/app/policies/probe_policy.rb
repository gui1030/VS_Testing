class ProbePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      super.eager_load(:unit).where(units: { probe_enabled: true })
    end
  end

  def index?
    user.probe_enabled && super
  end

  protected

  def default_read
    user.probe_enabled && model.unit.probe_enabled && super
  end

  def default_write
    user.probe_enabled && model.unit.probe_enabled && super
  end
end
