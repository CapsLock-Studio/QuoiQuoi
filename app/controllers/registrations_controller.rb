class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :cancel, :pay_show, :report_remittance]
  before_action :authenticate_user!, except: [:new, :create, :pay_show, :payment]

  skip_before_action :verify_authenticity_token, only: [:update, :return]

  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('registrations')

    @registrations = Registration.includes(:registration_payment).where(email: current_user.email).order(:id)
  end

  def close_index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('course.past')

    flash[:message]

    @registrations = Registration.where(email: current_user.email)

    #respond_to do |format|
      #format.html {render json: registrations}
      #format.html {render json: @registration}
    #end

    @registrations = @registrations.reject { |registration|
      (registration.course.time >= (Time.now + 5.hours))
    }

    respond_to do |format|
      format.html {render action: :index}
      #format.html {render json: @registrations}
    end
  end

  # GET /registration
  def new
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('register')

    flash[:message] = nil

    begin
      course_model = Course.includes(:course_translate).where(course_translates: {locale_id: session[:locale_id]})

      if CourseOptionGroup.where(locale_id: session[:locale_id], course_id: registration_params[:course_id]).size > 0
        course_model = course_model.includes(course_option_groups: [:course_options])
                           .where(course_option_groups: {locale_id: session[:locale_id]})
                           .order('course_option_groups.id')
                           .order('course_options.id')
      end

      @registration = course_model.find(registration_params[:course_id]).registrations.build(registration_params)

        #  -------- this way will delete current records --------
        # trim the course_options
        #@course.course_options = @course.course_options.where(locale_id: session[:locale_id])

      # Warn message to login user when they had registered
      if !current_user.nil? && Registration.where({course_id: @registration.course_id, email: current_user.email}).size > 0
        flash[:message] = t('had_registered_hint')
        flash[:status] = 'warning'
      end

    rescue ActiveRecord::RecordNotFound
      redirect_to action: :index
    end

    # @registration.subtotal = @registration.course.course_translates.find_by_locale_id(session[:locale_id]).price
    # @registration.registration_options.each do |option|
    #   @registration.subtotal += option.course_option.price
    # end


  end

  def create
    redirect_to controller: :registration_payment, action: Registration.new(registration_params).payment_method, params: params
  end

  # PUT/PATCH or POST /registrations/1
  # Receive CVS and ATM result here.
  def update
    flash.now[:icon] = 'fa-smile-o'
    flash.now[:message] = '謝謝你！報名已經完成。請你注意繳費期限以免報名自動取消喔！'
    flash.now[:status] = 'success'

    @registration = Registration.find(params['MerchantTradeNo'].delete('R'))
    # Check token to detect if post is from allpay
    # When payment method is CVS, RtnCode will return '1010073',
    # method is ATM, RtbCode will be '2'
    unless @registration.registration_payment.nil?

      if params['RtnCode'] == '10100073' || params['RtnCode'] == '2'
        @registration.registration_payment.update_columns(
            {
                expire_time: params['ExpireDate'],
                trade_no: params['TradeNo'],
                trade_time: params['TradeDate'],
                payment_no: params['PaymentNo'],
                bankcode: params['BankCode'],
                account: params['vAccount']
            }
        )

        @registration.reload

        render action: :show
      else
        render json: 'Not support payment method.'
      end
    else
      render json: 'Order not found.'
    end
  end

  def show
    if @registration.empty_expire_time?
      redirect_to controller: :registration_payment, action: :resume, id: @registration.registration_payment
    else
      add_breadcrumb t('home'), :root_path
      add_breadcrumb t('registration.all')
      add_breadcrumb t('detail')
    end
  end

  def pay_show
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('register'), :registrations_path
    add_breadcrumb t('payment')

    @registration = Registration.find(params[:id])
    if @registration.payment

      # if payment completed redirect to registrations page, not allow user to choose pay way again
      # then, if the payment is not completed, we need to delete uncompleted payment and let user to choose pay way again
      if @registration.payment.completed?
        redirect_to registrations_path
      else
        # delete all exists payment and rebuild one
        @registration.payment.destroy
        @payment = @registration.build_payment
      end
    else

      # has not choose pay way yet
      @payment = @registration.build_payment
    end
  end

  def payment
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('register')
    add_breadcrumb t('check_out')

    @registration = Course.includes(:course_translate)
                          .where(course_translates: {locale_id: session[:locale_id]}, id: registration_params[:course_id])
                          .first
                          .registrations.build(registration_params)
    #
    # @registration = Registration.new(registration_params)
    #
    # @registration.course.course_translate = CourseTranslate.find_by_course_id_and_locale_id(@registration.course_id, session[:locale_id])
    @registration.locale_id = session[:locale_id]

    unless current_user.nil?
      @registration.email = current_user.email
    end

    #  Warn message for guest when the email address had registered course
    if current_user.nil? && Registration.where({course_id: @registration.course_id, email: @registration.email}).size > 0
      flash[:message] = t('had_registered_hint')
      flash[:status] = 'warning'
    end
  end

  def destroy
    @registration = Registration.find(params[:id])
    if @registration.destroy
      redirect_to :back
    else
      render json: @registration.errors
    end
  end

  def cancel
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('registration.all'), :registrations_path
    add_breadcrumb t('detail')

    unless @registration.registration_payment.cancel?
      flash.now[:icon] = 'fa-user-times'
      flash.now[:message] = '你的報名已經取消, 謝謝你的合作!'
      flash.now[:status] = 'success'

      @registration.registration_payment.cancel = true
      @registration.registration_payment.cancel_reason = params[:cancel_reason]
      @registration.registration_payment.cancel_time = Time.now
      @registration.registration_payment.save!
    end

    render action: :show
  end

  def return
    flash.now[:icon] = 'fa-smile-o'
    flash.now[:status] = 'success'
    flash.now[:message] = t('payment_completed')

    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('registration.all'), :registrations_path
    add_breadcrumb t('detail')

    @registration = Registration.find(params['MerchantTradeNo'].delete('R'))

    # Not really update order entity, just show the newest status.
    @registration.registration_payment.trade_no = params['TradeNo']
    @registration.registration_payment.trade_time = params['TradeDate']
    @registration.registration_payment.payment_time = params['PaymentDate']
    @registration.registration_payment.completed =  true
    @registration.registration_payment.completed_time = Time.now

    render 'registrations/show'
  end

  def report_remittance
    # Status ==> Waiting   -> confirm: nil
    #            Confirmed -> confirm: true
    #            Confirmed -> confirm: false
    # If there are any reports waiting be reviewed, do nothing and show message to customer
    if @registration.registration_payment.registration_remittance_reports.where(confirm: nil).size <= 0
      @registration.registration_payment.registration_remittance_reports.create({
                                                               amount: params[:amount],
                                                               account: params[:account],
                                                               date: params[:date]
                                                           })
      flash.now[:icon] = 'fa-smile-o'
      flash.now[:status] = 'success'
      flash.now[:message] = t('report_remittance_hint')
    else
      flash.now[:icon] = 'fa-frown-o'
      flash.now[:status] = 'warning'
      flash.now[:message] = t('report_remittance_warning')
    end

    render action: :show
  end

  private
    def set_registration
      @registration = Registration.find_by_id_and_email(params[:id], current_user.email)
    end

    def registration_params
      params.require(:registration).permit(:attendance, :email, :name, :phone, :course_id, :course_option_id, :locale_id,
                                           :payment_method, registration_options_attributes: [:id, :course_option_id])
    end

    def set_discount
      @discount = 0
      UserGiftSerial.where(registration_id: @registration.id).each do |user_gift_serial|
        @discount += user_gift_serial.user_gift.gift.gift_translates.where(locale_id: @registration.locale_id).first.quota
      end
    end
end