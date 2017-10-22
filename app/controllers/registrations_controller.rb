class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :cancel, :pay_show, :report_remittance]
  before_action :authenticate_or_no, except: [:new, :create, :pay_show, :payment, :email, :verify]
  before_action :auto_redirect, only: [:email, :verify]

  skip_before_action :verify_authenticity_token, only: [:update, :return]

  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('registrations')

    @registrations = Registration.includes(:registration_payment)
                         .where(email: (current_user.nil?)? session[:no_authenticate_email] : current_user.email)
                         .order(:id)
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
      course_model = Course

      if CourseOptionGroup.where(locale_id: session[:locale_id], course_id: registration_params[:course_id]).size > 0
        course_model = course_model.includes(course_option_groups: [:course_options])
                           .where(course_option_groups: {locale_id: session[:locale_id]})
                           .order('course_option_groups.id')
                           .order('course_options.id')
      end

      @registration = course_model.find(registration_params[:course_id]).registrations.build(registration_params)
      @registration.locale_id = session[:locale_id]

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
    if current_user.nil?
      if verify_recaptcha || true
        session[:no_authenticate_verified] = true
        session[:no_authenticate_email] = registration_params[:email]
        redirect_to controller: :registration_payment, action: Registration.new(registration_params).payment_method, params: params
      else
        flash[:recaptcha] = '1'
        redirect_to action: :payment, params: params
      end
    else
      redirect_to controller: :registration_payment, action: Registration.new(registration_params).payment_method, params: params
    end
  end

  # PUT/PATCH or POST /registrations/1
  # Receive CVS and ATM result here.
  def update
    flash.now[:icon] = 'fa-smile-o'
    flash.now[:message] = t('registration_complete_hint')
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

        if @registration.atm?
          subject = t('mailer.subject.payment.atm')
        else
          subject = t('mailer.subject.payment.cvs')
        end

        RegistrationMailer.remind_to_pay(@registration.id, subject).deliver_later

        add_breadcrumb t('home'), :root_path
        add_breadcrumb t('registrations')

        @discount = 0

        begin
          @discount = @registration
                          .user_gift_serial
                          .user_gift
                          .gift
                          .gift_translates
                          .find_by_locale_id(@registration.locale_id)
                          .quota
        rescue
        end

        render action: :show
      else
        render json: 'Not support payment method.'
      end
    else
      render json: 'Registration not found.'
    end
  end

  def show
    unless (@registration.course.nil?)
      if (!@registration.registration_payment.cancel? && !@registration.course.canceled?) && @registration.empty_expire_time?
        redirect_to controller: :registration_payment, action: :resume, id: @registration.id
      end
    end

    @discount = 0

    begin
      @discount = @registration
                      .user_gift_serial
                      .user_gift
                      .gift
                      .gift_translates
                      .find_by_locale_id(@registration.locale_id)
                      .quota
    rescue
    end

    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('registration.all')
    add_breadcrumb t('detail')
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

    @gift_card_quota = 0
    @gift_card_serial = params[:gift_card_serial]

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

    if !@gift_card_serial.nil? and @gift_card_serial != ''
      begin
        user_gift_serial = UserGiftSerial.find_by_serial(@gift_card_serial)

        if user_gift_serial.used_time.nil?
          @gift_card_quota = user_gift_serial
                                 .user_gift
                                 .gift
                                 .gift_translates
                                 .find_by_locale_id(session[:locale_id])
                                 .quota
        else
          @gift_card_serial = '';

          flash.now[:icon] = 'fa-frown-o'
          flash.now[:status] = 'warning'
          flash.now[:message] = t('user_gift.oops')
        end
      rescue
        flash.now[:icon] = 'fa-frown-o'
        flash.now[:status] = 'warning'
        flash.now[:message] = t('user_gift.not_found')
      end

    #  Warn message for guest when the email address had registered course
    elsif flash[:recaptcha] != '1' && current_user.nil? && Registration.where({course_id: @registration.course_id, email: @registration.email}).size > 0
      flash[:message] = t('had_registered_hint')
      flash[:status] = 'warning'
    elsif flash[:recaptcha] == '1'
      flash[:icon] = 'fa fa-exclamation'
      flash[:message] = '請協助我們判斷您是不是機器人'
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

    if !@registration.registration_payment.completed? && !@registration.registration_payment.cancel?
      flash.now[:icon] = 'fa-user-times'
      flash.now[:message] = t('registration_cancel')
      flash.now[:status] = 'success'

      @registration.registration_payment.cancel = true
      @registration.registration_payment.cancel_reason = params[:cancel_reason]
      @registration.registration_payment.cancel_time = Time.now
      @registration.registration_payment.save!
    else
      flash.now[:icon] = 'fa-lightbulb-o'
      flash.now[:status] = 'success'
      flash.now[:message] = t('payment_already_completed')
    end

    render action: :show
  end

  # Allpay online trade complete.
  def return
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('registration.all'), :registrations_path
    add_breadcrumb t('detail')

    @registration = Registration.find(params['MerchantTradeNo'].delete('R').split('t')[0])

    @discount = 0

    begin
      @discount = @registration
                      .user_gift_serial
                      .user_gift
                      .gift
                      .gift_translates
                      .find_by_locale_id(@registration.locale_id)
                      .quota
    rescue
    end

    if params['RtnCode'] == '1' || params['RtnCode'] == '3'
      flash.now[:icon] = 'fa-smile-o'
      flash.now[:status] = 'success'
      flash.now[:message] = t('payment_completed')

      # Not really update order entity, just show the newest status.
      @registration.registration_payment.trade_no = params['TradeNo']
      @registration.registration_payment.trade_time = params['TradeDate']
      @registration.registration_payment.payment_time = params['PaymentDate']
      @registration.registration_payment.completed =  true
      @registration.registration_payment.completed_time = Time.now

      @registration.registration_payment.save!

      RegistrationMailer.completed_confirmation(@registration.id).deliver_later
    else
      errorCodes = JSON.parse(File.read('app/assets/javascripts/ecpayErrorCodes.json'))

      flash.now[:icon] = 'fa-exclamation-triangle'
      flash.now[:status] = 'danger'
      flash.now[:message] = "#{t('error_code')}: #{params['RtnCode']}, #{errorCodes[params['RtnCode']]} 🚫 #{t('payment_failed')}"
    end

    render 'registrations/show'
  end

  def report_remittance
    @discount = 0

    begin
      @discount = @registration
                      .user_gift_serial
                      .user_gift
                      .gift
                      .gift_translates
                      .find_by_locale_id(@registration.locale_id)
                      .quota
    rescue
    end

    # Status ==> Waiting   -> confirm: nil
    #            Confirmed -> confirm: true
    #            Confirmed -> confirm: false
    # If there are any reports waiting be reviewed, do nothing and show message to customer
    if @registration.registration_payment.registration_remittance_reports.where(confirm: nil).size <= 0
      report = @registration.registration_payment.registration_remittance_reports.create({
                                                               amount: params[:amount],
                                                               account: params[:account],
                                                               date: params[:date]
                                                           })
      RegistrationMailer.remind_remittance_report(report).deliver_later

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

  def email
  end

  def verify
    registration_found_count = Registration.where(email: params[:email]).size
    if (verify_recaptcha || true) && registration_found_count > 0
      session[:no_authenticate_verified] = true
      session[:no_authenticate_email] = params[:email]

      redirect_to registrations_path
    else
      flash[:icon] = 'fa fa-exclamation'
      flash[:status] = 'warning'
      if registration_found_count > 0
        flash[:message] = '請協助我們確認您是不是機器人'
      else
        flash[:message] = '找不到您的報名'
      end

      redirect_to action: :email
    end
  end

  private
    def set_registration
      @registration = Registration.find_by_id_and_email(params[:id], (current_user.nil?)? session[:no_authenticate_email] : current_user.email)
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

  def authenticate_or_no
    if !session[:no_authenticate_verified] && !user_signed_in?
      redirect_to action: :email
    end
  end

  def auto_redirect
    if session[:no_authenticate_verified] || user_signed_in?
      redirect_to action: :index
    end
  end
end
