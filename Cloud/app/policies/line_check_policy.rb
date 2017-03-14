class LineCheckPolicy < ProbePolicy
  def create?
    user.owns? model
  end
end
