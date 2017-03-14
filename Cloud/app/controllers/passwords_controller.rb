class PasswordsController < Devise::PasswordsController
  before_action :sign_out
  skip_after_action :verify_authorized
end
