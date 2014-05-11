class Admin::RemittancesController < AdminController
  authorize_resource

  before_action :set_remittance

  def show
  end

  def new
    unless @remittance
      @remittance = Remittance.new
      Locale.all.each do |locale|
        @remittance.remittance_translates.build(locale_id: locale.id)
      end
    end
  end

  def edit

  end

  def create
    unless @remittance
      @remittance = Remittance.new(remittance_params)
      respond_to do |format|
        if @remittance.save
          format.html {redirect_to action: :show}
        else
          format.html {render action: :new, status: :unprocessable_entity}
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @remittance.update_attributes(remittance_params)
        format.html {redirect_to action: :show}
      else
        format.html {render action: :edit}
      end
    end
  end

  def destroy

  end

  private
    def remittance_params
      params.require(:remittance).permit(:id, remittance_translates_attributes: [:id, :remittance_id, :name, :account, :code,
                                                                          :bank_name, :bank_address, :locale_id])
    end
    def set_remittance
      begin
        @remittance = Remittance.find(1)
      rescue ActiveRecord::RecordNotFound
        @remittance = nil
      end
    end
end
