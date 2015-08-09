class Admin::OrderRemittancesController < AdminController
  before_action :set_remittance, only: [:show, :edit, :update]
  add_breadcrumb '首頁', :admin_root_path

  def index
    # When there are no any exists condition, use the default value: nil, completed and denied to set up
    @search_filter = params[:search_filter] || %w[nil completed denied]
    query_condition = []
    query_condition << true if @search_filter.include?('completed')
    query_condition << false if @search_filter.include?('denied')
    query_condition << nil if @search_filter.include?('nil')

    @remittances = OrderRemittanceReport.where(confirm: query_condition)
  end

  def show
    add_breadcrumb '匯款紀錄列表', :admin_order_remittances_path
  end

  def check
    @remittances = OrderRemittanceReport.where(confirm: nil)
  end

  def edit
    add_breadcrumb '匯款紀錄列表', :admin_order_remittances_path
  end

  def update
    if @remittance.update_columns(remittance_params)

      @remittance.order_payment.completed = @remittance.confirm
      @remittance.order_payment.completed_time = Time.now if @remittance.confirm

      @remittance.order_payment.save!

      flash[:confirmed] = @remittance.confirm
      flash[:id] = @remittance.id

      # TO-DO: After setting the remittance status, we need to send mail to notify customers what's going on.

      redirect_to (params[:from_check])? check_admin_order_remittances_path : admin_order_remittances_path
    else
      render json: @remittance.errors
    end
  end

  private
  def set_remittance
    @remittance = OrderRemittanceReport.find(params[:id])
  end

  def remittance_params
    params.permit(:confirm, :message)
  end
end
