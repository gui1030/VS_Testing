class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case user
      when Admin then scope.all
      else scope.none
      end
    end
  end

  def index?
    user.is_a? Admin
  end

  def destroy?
    user != model && super
  end

  def reset_password?
    default_read
  end

  def send_confirmation?
    default_read
  end

  def permitted_attributes
    attributes =
      [
        :firstname,
        :lastname,
        :email,
        :avatar,
        :time_zone,
        :default_units,
        :email_notification,
        :daily_notification,
        :sms_notification,
        :report_frequency,
        :report_time,
        :report_weekday,
        :report_day,
        :phone
      ]
    attributes << [:probe_enabled] if user.is_a? Admin
    attributes
  end

  protected

  def default_read
    user == model || super
  end

  def default_write
    user == model || super
  end
end
