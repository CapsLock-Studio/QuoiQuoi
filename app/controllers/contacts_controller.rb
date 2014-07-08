class ContactsController < ApplicationController
  def create
    respond_to do |format|
      if verify_recaptcha
        @contact_us = ContactUs.new(contact_us_params)
        if @contact_us.save
          flash[:status] = 'success'
          flash[:message] = t('thanks_text')
          format.html {redirect_to :back}
        else
          format.html {render json: 'Saving error please contact the web application holder.'}
        end
      else
        format.html do
          flash[:status] = 'danger'
          flash[:name] = contact_us_params[:name]
          flash[:email] = contact_us_params[:email]
          flash[:content] = contact_us_params[:content]
          flash[:message] = t('recaptcha_error')
          redirect_to :back
        end
      end
    end
  end

  private
    def contact_us_params
      params.require(:contact_us).permit(:name, :email, :content)
    end
end
