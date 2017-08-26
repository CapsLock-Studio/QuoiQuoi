class RegistrationPaymentController < ApplicationController
  before_action :set_registration, except: [:resume, :webatm_resume, :credit_card_resume, :alipay_resume]
  before_action :check_payment_is_completed, only: [:resume, :webatm_resume, :credit_card_resume, :alipay_resume]
  before_action :authenticate_or_no
  before_action :set_breadcrumb

  def remittance
    flash[:icon] = 'fa-smile-o'
    flash[:message] = t('registration_complete_hint')
    flash[:status] = 'success'

    @registration.create_registration_payment(
        {
            amount: @registration.subtotal,
            expire_time: (Time.now + 4.days).end_of_day
        })

    # Send email to remind customer take the payment
    RegistrationMailer.remind_to_pay(@registration.id, t('mailer.subject.payment.remittance')).deliver_later

    redirect_to registration_path(@registration)
  end

  def cvs_ibon
    send_request_to_allpay(@registration, 'CVS', {
                                          ChooseSubPayment: 'IBON',
                                      })
  end

  def cvs_family
    send_request_to_allpay(@registration, 'CVS', {
                                          ChooseSubPayment: 'FAMILY',
                                      })
  end

  def resume
    registration = Registration.find(params[:id])

    case registration.payment_method
      when registration.payment_method['cvs_family']
        if registration.registration_payment.payment_no.nil?
          send_request_to_allpay(registration, 'CVS', {
                                                 ChooseSubPayment: 'FAMILY',
                                             })
        else
          render json: 'ERROR!!'
        end
      when registration.payment_method['cvs_ibon']
        if registration.registration_payment.payment_no.nil?
          send_request_to_allpay(registration, 'CVS', {
                                                 ChooseSubPayment: 'IBON',
                                             })
        else
          render json: 'ERROR!!'
        end
      when registration.payment_method['atm']
        if registration.registration_payment.account.nil? || registration.registration_payment.account.nil?
          send_request_to_allpay(registration, 'ATM')
        else
          render json: 'ERROR!!'
        end
      else
        render json: 'ERROR!!'
    end
  end

  def paypal

    #render json: Paypal::Express::Request.new(PAYPAL_CONFIG)
    paypal_response = Paypal::Express::Request.new(PAYPAL_CONFIG).setup(
        Paypal::Payment::Request.new(
            currency_code: Locale.find(@registration.locale_id).currency,
            description: @website_title,
            quantity: 1,
            amount: @registration.subtotal
        ),
        url_for(controller: :registration_payment_callback, action: :paypal),
        cancel_registration_url(@registration),
        pay_on_paypal: true,
        no_shipping: true
    )

    @registration.create_registration_payment(
        {
            redirect_uri: paypal_response.redirect_uri,
            token: paypal_response.token,
            amount: @registration.subtotal,
            trade_time: paypal_response.timestamp
        })

    # Send email to customer at tomorrow midnight if his/her payment is not completed
    OnlinePaymentRemindJob.set(wait_until: Date.tomorrow.midnight).perform_later(@registration.registration_payment)

    redirect_to paypal_response.redirect_uri
  end

  def credit_card
    send_request_to_allpay(@registration, 'Credit', {
                                          OrderResultURL: return_registration_url(@registration)
                                      })

    # Send email to customer at tomorrow midnight if his/her payment is not completed
    OnlinePaymentRemindJob.set(wait_until: Date.tomorrow.midnight).perform_later(@registration.registration_payment)
  end

  def credit_card_resume
    registration = Registration.find(params[:id])

    # Resend a order payment to AllPay
    send_request_to_allpay(registration, 'Credit', {
                                    OrderResultURL: return_registration_url(registration)
                                })
  end

  def webatm
    send_request_to_allpay(@registration, 'WebATM', {
                                          OrderResultURL: return_registration_url(@registration)
                                      })

    # Send email to customer at tomorrow midnight if his/her payment is not completed
    OnlinePaymentRemindJob.set(wait_until: Date.tomorrow.midnight).perform_later(@registration.registration_payment)
  end

  def webatm_resume
    registration = Registration.find(params[:id])

    # Resend a order payment to AllPay
    send_request_to_allpay(registration, 'WebATM', {
                                           OrderResultURL: return_registration_url(registration)
                                       })
  end

  def atm
    send_request_to_allpay(@registration, 'ATM')
  end

  def alipay
    send_request_to_allpay(@registration, 'Alipay', {
                                          AlipayItemName: "#{t('course.name')}: #{@registration.course.course_translates.find_by_locale_id(@registration.locale_id).name}, #{t('registration.attendance')}: #{@registration.attendance}",
                                          AlipayItemCounts: '1',
                                          AlipayItemPrice: "#{@registration.subtotal.to_i}",
                                          Email: @registration.email,
                                          PhoneNo: @registration.phone,
                                          UserName: @registration.name
                                      })

    # Send email to customer at tomorrow midnight if his/her payment is not completed
    OnlinePaymentRemindJob.set(wait_until: Date.tomorrow.midnight).perform_later(@registration.registration_payment)
  end

  def alipay_resume
    registration = Registration.find(params[:id])

    # # Resend a order payment to AllPay
    send_request_to_allpay(registration, 'Alipay', {
                                                       AlipayItemName: "#{t('course.name')}: #{registration.course.course_translates.find_by_locale_id(registration.locale_id).name}, #{t('registration.attendance')}: #{registration.attendance}",
                                                       AlipayItemCounts: '1',
                                                       AlipayItemPrice: "#{registration.subtotal.to_i}",
                                                       Email: registration.email,
                                                       PhoneNo: registration.phone,
                                                       UserName: registration.name
                                                   })
  end

  private

  # Complete register here to prevent that is the registration but no registration_payment
  def set_registration
    @registration = Registration.new(registration_params)

    unless current_user.nil?
      @registration.user_id = current_user.id
    end

    # Getting total tuition and store it as registration's amount
    @registration.subtotal = @registration.tuition
    @registration.checkout = true
    @registration.checkout_time = Time.now

    user_gift_serial = UserGiftSerial.find_by_serial(params[:user_gift_serial])

    begin
      if !params[:user_gift_serial].nil? && params[:user_gift_serial] != ''

        if user_gift_serial.used_time.nil?
          discount = user_gift_serial
                         .user_gift
                         .gift
                         .gift_translates
                         .find_by_locale_id(@registration.locale_id)
                         .quota

          @registration.subtotal -= discount

          if @registration.subtotal < 0
            @registration.subtotal = 0
          end
        end
      end
    end

    @registration.save!

    begin
      user_gift_serial.registration_id = @registration.id
      user_gift_serial.used_time = Time.now
      user_gift_serial.email = @registration.user.nil? ? @registration.email : @registration.user.email
      user_gift_serial.save

      UserGiftMailer.used_remind(user_gift_serial.id).deliver_later
    end
  end

  def set_breadcrumb
    add_breadcrumb t('home'), :root_path
    add_breadcrumb I18n.t('register')
    add_breadcrumb I18n.t('check_out')
  end

  def registration_params
    registration_info = params.require(:registration)

    if registration_info.is_a? String
      recombined_raw_params = registration_info.split('&').map do |raw_data|
        pair_data = raw_data.split('=')
        "registration%5B#{pair_data[0]}%5D=#{pair_data[1]}"
      end.join('&')

      raw_params = Rack::Utils.parse_nested_query recombined_raw_params

      registration_info = ActionController::Parameters.new(raw_params).require(:registration)
    end

    registration_info.permit(:attendance, :email, :name, :phone, :course_id, :course_option_id, :locale_id, :payment_method,
                             registration_options_attributes: [:id, :course_option_id])
  end

  def send_request_to_allpay(registration, payment, options = nil)
    @form_data = {
        MerchantID: AllPay.merchant_id,
        MerchantTradeNo: "R#{registration.id}t#{Time.now.to_i}",
        MerchantTradeDate: registration.checkout_time.strftime('%Y/%m/%d %H:%I:%S'),
        PaymentType: 'aio',
        TotalAmount: registration.subtotal.to_i,
        TradeDesc: @website_title,
        ItemName: "#{t('course.name')}: #{registration.course.course_translates.find_by_locale_id(registration.locale_id).name}, #{t('registration.attendance')}: #{registration.attendance}",
        ReturnURL: url_for(controller: :registration_payment_callback, action: :allpay_complete),
        ChoosePayment: payment,
        ClientRedirectURL: registration_url(registration),
    }

    unless options.nil?
      @form_data = @form_data.merge(options)
    end

    # render json: @form_data

    # Record payment information
    if registration.registration_payment.nil?
      registration.create_registration_payment(
          {
              amount: registration.subtotal
          })
    end

    render template: 'order_payment/all_pay_form'
  end

  def check_payment_is_completed
    # Check if the payment is completed or not, stop resume payment action.
    registration = Registration.find(params[:id])
    if registration.registration_payment.completed?
      flash[:icon] = 'fa-lightbulb-o'
      flash[:status] = 'success'
      flash[:message] = t('payment_already_completed')

      redirect_to registration_path(registration)
    end
  end

  private
  def authenticate_or_no
    if session[:no_authenticate_verified]
    else
      authenticate_user!
    end
  end
end