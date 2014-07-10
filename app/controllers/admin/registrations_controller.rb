class Admin::RegistrationsController < AdminController
  authorize_resource

  before_action :set_check_payment, only: [:show, :check_show]
  before_action :set_discount, only: [:show, :check_show]

  def index
    @registrations = Registration.all.order(created_at: :desc)
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

    def set_discount
      @discount = 0
      UserGiftSerial.where(registration_id: @payment.registration.id).each do |user_gift_serial|
        @discount += user_gift_serial.user_gift.gift.gift_translates.where(locale_id: @payment.registration.locale_id).first.quota
      end
    end
end