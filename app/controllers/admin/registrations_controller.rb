class Admin::RegistrationsController < AdminController
  authorize_resource

  before_action :set_registration, only: [:show, :destroy]
  before_action :remove_duplicate_payment, only: [:show, :check_show]
  before_action :set_check_payment, only: [:show, :check_show]
  before_action :set_discount, only: [:show, :check_show]
  before_action :set_total_attendance, only: [:show, :check_show]

  def index

    @course = Course.includes(:registrations, registrations: :registration_payment).find(params[:course_id])
  end

  def show
    add_breadcrumb '首頁', :admin_root_path
    add_breadcrumb '所有課程', :admin_courses_path
    add_breadcrumb '報名詳細'


  end

  def canceled
    @registrations = Registration.includes(:registration_payment).where(registration_payments: {cancel: true})

    unless cancel_search_filter_params.nil?
      @search_filter = cancel_search_filter_params
      conditions = cancel_search_filter_params

      unless conditions['cancel_time'].nil?
        dates = conditions['cancel_time'].split(' - ')
        conditions['cancel_time'] = dates[0]..dates[1]

        # Add search conditions to orders
        @registrations = @registrations.where(registration_payments: conditions)
      end
    end
  end

  def destroy
    if @registration.destroy!
      redirect_to :back
    end

    flash[:id] = params[:id]
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

  def set_registration
    @registration = Registration.find(params[:id])
  end

  def status_params
    unless params[:canceled].nil?
      params[:canceled_time] = Time.now
    end
    unless params[:refunded_time].nil?
      params[:refunded_time] = Time.now
    end

    params.permit(:canceled, :canceled_time, :refunded, :refunded_time)
  end

  def cancel_search_filter_params
    unless params[:search_filter].nil?
      sanitize_params = params[:search_filter].permit(:cancel_time)
      sanitize_params.delete('cancel_time') if sanitize_params['cancel_time'].blank?
      sanitize_params
    end
  end
end