class UsersController < ApplicationController
  before_action :set_user, except: :unsubscribe
  skip_before_action :authenticate_user!, only: :unsubscribe
  skip_after_action :verify_authorized, only: :unsubscribe

  def show
  end

  def edit
    self.referer = request.referer
  end

  def destroy
    if @user.destroy
      redirect_to :back, notice: 'User deleted'
    else
      redirect_to :back, alert: !user.errors.full_messages.first
    end
  end

  def reset_password
    @user.send_reset_password_instructions
    redirect_to :back, notice: 'Password reset email sent to ' + @user.email
  end

  def send_confirmation
    @user.send_confirmation_instructions
    redirect_to :back, notice: 'Confirmation email sent to ' + @user.email
  end

  def unsubscribe
    token = Digest::SHA1.hexdigest(params[:token] || '')
    @user = User.find_by email_token: token

    if @user
      @user.email_token = nil
      case params[:type].to_sym
      when :email_notifications
        @user.email_notification = false
        flash.now[:notice] = 'Unsubscribed from email notifications'
      when :reports
        @user.daily_notification = false
        flash.now[:notice] = 'Unsubscribed from reports'
      else
        flash.now[:alert] = 'Invalid Type'
      end
      @user.save!
    else
      flash.now[:alert] = 'Invalid Link'
    end
    render text: nil, layout: 'application'
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  def new_user_params
    params.permit(policy(User).permitted_new_attributes)
  end

  def user_params
    params.require(:user).permit(policy(User).permitted_attributes)
  end
end
