class AccountConfirmationController < ApplicationController
  include Wicked::Wizard

  steps :account, :contact, :notifications, :reports, :confirmation
  before_action :authorize_user
  before_action :set_current_step

  def show
    @user = current_user
    @account = @user.account
    render_wizard
  end

  def update
    @user = current_user
    @account = @user.account
    case step
    when :account
      @account.assign_attributes(account_params)
      render_wizard @account
    when :contact, :notifications, :reports
      @user.assign_attributes(user_params)
      render_wizard @user
    when :confirmation
      @account.confirm
      render_wizard @account
    end
  end

  private

  def authorize_user
    authorize Account, :confirm?
  end

  def user_params
    params
      .require(:account_user)
      .permit(:firstname,
              :lastname,
              :phone,
              :email_notification,
              :sms_notification,
              :daily_notification,
              :report_frequency,
              :report_time,
              :report_weekday,
              :report_day)
  end

  def account_params
    params
      .require(:account)
      .permit(:name)
  end

  def current_step
    case step
    when :account
      1
    when :contact
      2
    when :notifications
      3
    when :reports
      4
    when :confirmation
      5
    else
      0
    end
  end

  def set_current_step
    @current_step = current_step
  end
end
