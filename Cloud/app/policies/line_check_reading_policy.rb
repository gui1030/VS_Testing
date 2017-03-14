class LineCheckReadingPolicy < ProbePolicy
  def update?
    user.owns? model
  end

  protected

  def default_write
    false
  end
end
