class ContactsController < ApplicationController
  def new
    @contact = Contact.new
    @user = current_user
    authorize @contact
  end

  def create
    @contact = Contact.new(params[:contact])
    @user = current_user
    authorize @contact
    @contact.request = request
    if @contact.deliver
      flash[:notice] = 'Thank you for your message. We will contact you soon!'
      redirect_to action: 'new'
    else
      flash[:error] = 'Cannot send message.'
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message, :attachment)
  end
end
