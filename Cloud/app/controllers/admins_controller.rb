class AdminsController < ApplicationController
  def index
    authorize Admin
    @admins = Admin.all
  end

  def new
    @admin = Admin.new
    authorize @admin
  end

  def create
    @admin = Admin.new(admin_params)
    authorize @admin

    if @admin.save
      redirect_to admins_path, notice: 'Admin created'
    else
      render :new
    end
  end

  def update
    @user = Admin.find params[:id]
    authorize @user

    if @user.update admin_params
      redirect_to referer, notice: 'User Updated'
    else
      render 'users/edit'
    end
  end

  private

  def admin_params
    params.require(:admin).permit(policy(Admin).permitted_attributes)
  end
end
