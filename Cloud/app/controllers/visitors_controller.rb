class VisitorsController < ApplicationController
  skip_after_action :verify_authorized

  def index
    case current_user
    when Admin
      redirect_to accounts_path
    when AccountUser
      if current_user.registration_complete?
        redirect_to current_user.account
      else
        redirect_to account_confirmation_index_path
      end
    when UnitUser
      redirect_to current_user.unit
    end
  end
end
