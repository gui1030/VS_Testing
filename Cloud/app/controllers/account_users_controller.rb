class AccountUsersController < ApplicationController
  before_action :set_account, except: :update

  def index
    authorize AccountUser
    @users = @account.users
  end

  def new
    @user = @account.users.new
    authorize @user
  end

  def create
    @user = @account.users.new(user_params)
    authorize @user

    if @user.save
      redirect_to account_users_path(@account), notice: 'Account User created'
    else
      flash.now[:alert] = @user.errors.full_messages.first
      render :new
    end
  end

  def update
    @user = AccountUser.find params[:id]
    @user.transaction do
      # AccountUser#unit_ids= persists units because rails can't even
      # stick to its own conventions. So we wrap it in a transaction to reject
      # authorization errors
      @user.assign_attributes user_params
      authorize @user
      if @user.save
        redirect_to referer, notice: 'User updated'
      else
        render '/users/edit'
      end
    end
  end

  private

  def set_account
    @account = Account.find params[:account_id]
  end

  def user_params
    params.require(:account_user).permit(policy(AccountUser).permitted_attributes)
  end
end
