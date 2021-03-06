# app/controllers/confirmations_controller.rb
class ConfirmationsController < Devise::ConfirmationsController
  # Remove the first skip_before_filter (:require_no_authentication) if you
  # don't want to enable logged users to access the confirmation page.

  skip_before_action :require_no_authentication
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized

  # PUT /resource/confirmation
  def update
    original_token = params[:confirmation_token]

    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, original_token)

    if @confirmable.no_password?

      flash[:alert] = params[:user]

      @confirmable.attempt_set_password(params[:user])
      if @confirmable.valid? && @confirmable.password_match?
        do_confirm
      else
        do_show
        @confirmable.errors.clear # so that we wont render :new
      end
    else
      @confirmable.errors.add(:email, :password_already_set)
    end

    redirect_to root_path unless @confirmable.errors.empty?
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    sign_out current_user

    with_unconfirmed_confirmable do
      if @confirmable.no_password?
        do_show
      else
        do_confirm
      end
    end
    unless @confirmable.errors.empty?
      self.resource = @confirmable
      redirect_to root_path # Change this if you don't have the views on default path
    end
  end

  protected

  def with_unconfirmed_confirmable
    original_token = params[:confirmation_token]

    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, original_token)

    @confirmable.only_if_unconfirmed { yield } unless @confirmable.new_record?
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render 'devise/confirmations/show' # Change this if you don't have the views on default path
  end

  def do_confirm
    @confirmable.confirm
    sign_in_and_redirect(resource_name, @confirmable)
  end
end
