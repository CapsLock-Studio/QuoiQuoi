class Admin::RegistrationsController < AdminController
  authorize_resource

  before_action :remove_duplicate_payment, only: [:show, :check_show]
  before_action :set_check_payment, only: [:show, :check_show]
  before_action :set_discount, only: [:show, :check_show]
  before_action :set_total_attendance, only: [:show, :check_show]

  def index
    @registrations = Registration.all.order(created_at: :desc)
  end

  def show
    add_breadcrumb '首頁', :admin_root_path
    add_breadcrumb '所有報名課程記錄', :admin_registrations_path
    add_breadcrumb '詳細報名課程記錄'

    respond_to do |format|
      format.html {render action: :check_show}
    end
  end

  def check
    @payments = Payment.where(canceled: false, completed: false).where.not(registration_id: '', pay_time: nil)
  end

  def check_show
    add_breadcrumb '首頁', :admin_root_path
    add_breadcrumb '所有報名課程匯款', :check_admin_registrations_path
    add_breadcrumb '詳細報名課程匯款'
  end

  private
    def set_check_payment
      @registration = Registration.find(params[:id])
      @payment = @registration.payment
    end

    def remove_duplicate_payment
      payments = Payment.where(registration_id: params[:id]).order(:created_at)
      if payments.length > 1
        payments.first.destroy
      end
    end

    def set_discount
      @discount = 0
      UserGiftSerial.where(registration_id: @registration.id).each do |user_gift_serial|
        @discount += user_gift_serial.user_gift.gift.gift_translates.where(locale_id: @payment.registration.locale_id).first.quota
      end
    end

    def set_total_attendance
      @total_attendance = 0

      payments = Payment.where(completed: true).where.not(registration_id: ['', nil])
      payments.each do |payment|
        if payment.registration && payment.registration.course_id == @registration.course_id
          @total_attendance += payment.registration.attendance
        end
      end
    end
end