class Admin::UserGiftRemittancesController < AdminController
  before_action :set_remittance, only: [:show, :edit, :update]
  add_breadcrumb '首頁', :admin_root_path

  def index
    # When there are no any exists condition, use the default value: nil, completed and denied to set up
    @search_filter = params[:search_filter] || %w[nil completed denied]
    query_condition = []
    query_condition << true if @search_filter.include?('completed')
    query_condition << false if @search_filter.include?('denied')
    query_condition << nil if @search_filter.include?('nil')

    @remittances = UserGiftRemittanceReport.where(confirm: query_condition)
  end

  def show
    add_breadcrumb '所有匯款紀錄', :admin_user_gift_remittances_path
    add_breadcrumb '詳細匯款紀錄'
  end

  def check
    @remittances = UserGiftRemittanceReport.where(confirm: nil)
  end

  def edit
    add_breadcrumb '所有匯款紀錄', :admin_user_gift_remittances_path
    add_breadcrumb '詳細匯款紀錄'

    unless @remittance.confirm.nil?
      redirect_to action: :show
    end
  end

  def update
    @remittance.confirm = remittance_params[:confirm]
    @remittance.message = remittance_params[:message]

    if @remittance.save

      @remittance.user_gift_payment.completed = @remittance.confirm
      @remittance.user_gift_payment.completed_time = Time.now if @remittance.confirm

      @remittance.user_gift_payment.save!

      # Status ==> Waiting   -> confirm: nil
      #            Confirmed -> confirm: true
      #            Confirmed -> confirm: false
      unless @remittance.confirm.nil?
        if @remittance.confirm?
          UserGiftMailer.completed_confirmation(@remittance.user_gift_payment.user_gift.id).deliver_later
        else
          UserGiftMailer.request_remit_payment_again(@remittance).deliver_later
        end
      end

      flash[:confirmed] = @remittance.confirm
      flash[:id] = @remittance.id

      # TO-DO: After setting the remittance status, we need to send mail to notify customers what's going on.

      redirect_to (params[:from_check] == 'true')? check_admin_user_gift_remittances_path : admin_user_gift_remittances_path
    else
      render json: @remittance.errors
    end
  end

  private
  def set_remittance
    @remittance = UserGiftRemittanceReport.find(params[:id])
  end

  def remittance_params
    params.permit(:confirm, :message)
  end
end
