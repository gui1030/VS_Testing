module DeviseHelper
  def devise_error_messages!
    if devise_controller? && resource.errors.any?
      flash.now[:alert] = resource.errors.full_messages.first
    end
  end
end
