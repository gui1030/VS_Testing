class NotifyEventsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    authorize @user, :show?
    @events = @user.notify_events.page(params[:page])
  end
end
