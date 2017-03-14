# app/controllers/heath_check_controller.rb
class HealthCheckController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized, if: :current_user
  def index
    render text: "I am alive!\n"
  end
end
