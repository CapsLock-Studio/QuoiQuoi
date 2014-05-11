class Admin::RegistrationsController < AdminController
  authorize_resource

  before_action :set_check_payment, only: [:show, :check_show]

  def index
    @registrations = Registration.all
  end

  def show
    add_breadcrumb '首頁', :admin_root_path
    add_breadcrumb '所有報名課程記錄', :admin_registrations_path
    add_breadcrumb '詳細報名課程記錄'

    @total_attendance = 0

    payments = Payment.where.not(registration_id: '')
    payments.each do |payment|
      @total_attendance += payment.registration.attendance
    end

    respond_to do |format|
      format.html {render action: :check_show}
    end
  end

  def check
    @payments = Payment.where(canceled: false, completed: false).where.not(registration_id: '', amount: 0)
  end

  def check_show
    add_breadcrumb '首頁', :admin_root_path
    add_breadcrumb '所有報名課程匯款', :check_admin_registrations_path
    add_breadcrumb '詳細報名課程匯款'

    @total_attendance = 0

    payments = Payment.where(completed: false).where.not(registration_id: '', amount: 0)
    payments.each do |payment|
      @total_attendance += payment.registration.attendance
    end
  end

  private
    def set_check_payment
      @payment = Payment.where(registration_id: params[:id]).first
    end
end