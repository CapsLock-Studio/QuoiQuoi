class Admin::PaymentsController < AdminController
  authorize_resource

  before_action :set_payment, except: [:check, :index]
  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '付款記錄', :admin_payments_path

  def index
    @payments = Payment.all
  end

  def show
    add_breadcrumb '詳細付款記錄'
  end

  def new

  end

  def edit

  end

  def create

  end

  def update
    respond_to do |format|
      if @payment.update_attribute(:completed, true)
        if @payment.order
          OrderMailer.remind(@payment.order_id).deliver
          format.html {redirect_to check_admin_orders_path}
        elsif @payment.registration
          RegistrationMailer.remind(@payment.registration_id).deliver
          format.html {redirect_to check_admin_registrations_path}
        elsif @payment.user_gift

          1..@payment.user_gift.quantity.times do |i|
            UserGiftSerial.new(user_gift_id: @payment.user_gift_id, serial: get_unique_random_string).save
          end

          UserGiftMailer.completed_remind(@payment.user_gift_id).deliver
          format.html {redirect_to check_admin_user_gifts_path}
        end
      else
        format.html {render json: @payment.errors}
      end
    end
  end

  # remittance information not correct, reset value
  def uncheck
    respond_to do |format|

      if @payment.order
        OrderMailer.re_remittance_remind(@payment.order_id, @payment.amount, @payment.identifier, @payment.pay_time).deliver
      elsif @payment.registration
        RegistrationMailer.re_remittance_remind(@payment.registration_id, @payment.amount, @payment.identifier, @payment.pay_time).deliver
      elsif @payment.user_gift
        UserGiftMailer.re_remittance_remind(@payment.user_gift_id, @payment.amount, @payment.identifier, @payment.pay_time).deliver
      end

      @payment.amount = 0
      @payment.identifier = ''
      @payment.pay_time = ''
      if @payment.save!(validate: false)
        if @payment.order
          format.html {redirect_to check_admin_orders_path}
        elsif @payment.registration

          format.html {redirect_to check_admin_registrations_path}
        elsif @payment.user_gift
          format.html {redirect_to check_admin_user_gifts_path}
        end
      else
        format.html {render json: @payment.errors}
      end
    end
  end

  def destroy

  end

  def check
    @payments = Payment.where(completed: false).where.not(amount: 0, pay_time: nil)
  end

  private
    def payment_params

    end

    def set_payment
      @payment = Payment.find(params[:id])
    end
end
