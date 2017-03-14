class ApplicationController < ActionController::Base
  include PunditHelper if Rails.env.development?
  include SessionHelper

  attr_accessor :temp_converter

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  force_ssl if: :ssl_configured?
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  around_action :use_time_zone, if: :current_user
  before_action :create_temp_converter, if: :current_user
  after_action :verify_authorized, if: :current_user

  private

  def ssl_configured?
    Rails.env.production?
  end

  def use_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def create_temp_converter
    @temp_converter = ConversionService.new(current_user.default_units)
  end
end
