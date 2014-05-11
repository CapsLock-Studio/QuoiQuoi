class Admin::ContactsController < AdminController
  authorize_resource

  before_action :set_contact

  def show

  end

  def new
    unless @contact
      @contact = Contact.new
      Locale.all.each do |locale|
        @contact.contact_translates.build(locale_id: locale.id)
      end
    end
  end

  def edit

  end

  def create
    @contact = Contact.new(contact_params)
    respond_to do |format|
      if @contact.save
        format.html {redirect_to action: :show}
      else
        format.html {render json: @contact.errors}
      end
    end
  end

  def update
    respond_to do |format|
      if @contact.update_attributes(contact_params)
        format.html {redirect_to action: :show}
      else
        format.html {render json: @contact.errors}
      end
    end
  end

  private
    def set_contact
      begin
        @contact = Contact.find(1)
      rescue ActiveRecord::RecordNotFound
        @contact = nil
      end
    end

    def contact_params
      params.require(:contact).permit(:id, contact_translates_attributes: [:id, :locale_id, :contact_id, :email, :mobile, :phone, :address, :business_hour])
    end
end