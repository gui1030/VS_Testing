module AccountConfirmationHelper
  def current_step
    @current_step
  end

  def step_modifier(step_number)
    if step_number < current_step
      'past'
    elsif step_number == current_step
      'current'
    else
      'future'
    end
  end

  def step_class(step_number)
    "step-#{step_number} #{step_modifier(step_number)}"
  end
end
