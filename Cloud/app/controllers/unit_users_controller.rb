class UnitUsersController < ApplicationController
  before_action :set_unit, except: :update

  def index
    authorize UnitUser
    @users = @unit.users
  end

  def new
    @user = @unit.users.new
    authorize @user
  end

  def create
    @user = @unit.users.new(user_params)
    authorize @user

    if @user.save
      redirect_to unit_users_path(@unit), notice: 'Unit User created'
    else
      render :new
    end
  end

  def update
    @user = UnitUser.find params[:id]
    authorize @user

    if @user.update user_params
      redirect_to referer, notice: 'User updated'
    else
      render '/users/edit'
    end
  end

  private

  def set_unit
    @unit = Unit.find params[:unit_id]
  end

  def user_params
    params.require(:unit_user).permit(policy(UnitUser).permitted_attributes)
  end
end
