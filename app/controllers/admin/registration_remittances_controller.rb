class Admin::RegistrationRemittancesController < AdminController
  before_action :set_remittance, only: [:show, :edit, :update]
  add_breadcrumb '首頁', :admin_root_path

  def index
    # When there are no any exists condition, use the default value: nil, completed and denied to set up
    @search_filter = params[:search_filter] || %w[nil completed denied]
    query_condition = []
    query_condition << true if @search_filter.include?('completed')
    query_condition << false if @search_filter.include?('denied')
    query_condition << nil if @search_filter.include?('nil')

    @remittances = RegistrationRemittanceReport.where(confirm: query_condition)
  end

  def show
    add_breadcrumb '所有匯款紀錄', :admin_registration_remittances_path
    add_breadcrumb '詳細匯款紀錄'
  end

  def check
    @remittances = RegistrationRemittanceReport.where(confirm: nil)
  end

  def edit
    add_breadcrumb '所有匯款紀錄', :admin_registration_remittances_path
    add_breadcrumb '詳細匯款紀錄'
  end

  def update
    @remittance.confirm = remittance_params[:confirm]
    @remittance.message = remittance_params[:message]

    if @remittance.save

      @remittance.registration_payment.completed = @remittance.confirm
      @remittance.registration_payment.completed_time = Time.now if @remittance.confirm

      @remittance.registration_payment.save!

      flash[:confirmed] = @remittance.confirm
      flash[:id] = @remittance.id

      # TO-DO: After setting the remittance status, we need to send mail to notify customers what's going on.
      redirect_to (params[:from_check] == 'true')? check_admin_registration_remittances_path : admin_registration_remittances_path
    else
      render json: @remittance.errors
    end
  end

  private
  def set_remittance
    @remittance = RegistrationRemittanceReport.find(params[:id])
  end

  def remittance_params
    params.permit(:confirm, :message)
  end
end
