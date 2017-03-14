class AccountsController < ApplicationController
  before_action :set_account, except: [:index, :new, :create]

  def index
    authorize Account
    @accounts = params[:search].present? ? Account.search(params[:search]) : Account.all
    @accounts = @accounts.order('name').page(params[:page])
  end

  def new
    @account = Account.new
    authorize @account
  end

  def create
    @account = Account.new(account_params)
    authorize @account

    if @account.save
      redirect_to @account, notice: 'Account created'
    else
      render :new
    end
  end

  def show
    @units = policy_scope(@account.units)
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to @account, notice: 'Account updated'
    else
      render :edit
    end
  end

  def destroy
    if @account.destroy
      redirect_to accounts_path, notice: "Deleted Account: #{@account}"
    else
      redirect_to :back, alert: 'Error occured while deleting account'
    end
  end

  private

  def set_account
    @account = Account.find params[:id]
    authorize @account
  end

  def account_params
    params.require(:account).permit(policy(Account).permitted_attributes)
  end
end
