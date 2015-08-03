class RegistrationPaymentController < ApplicationController
  before_action :set_registration, except: [:resume, :webatm_resume, :alipay_resume]
  before_action :set_breadcrumb

  def remittance
    flash[:icon] = 'fa-smile-o'
    flash[:message] = '謝謝你！訂單已經成立。請你注意繳費期限以免訂單自動取消喔！'
    flash[:status] = 'success'

    @registration.create_registration_payment(
        {
            amount: @registration.subtotal,
            expire_time: Date.today + 7.days
        })

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
    registration = duplicate_registration_payment(params[:id]).registration

    case registration.payment_method
      when registration.payment_method['cvs_family']
        send_request_to_allpay(registration, 'CVS', {
                                        ChooseSubPayment: 'FAMILY',
                                    })
      when registration.payment_method['cvs_ibon']
        send_request_to_allpay(registration, 'CVS', {
                                        ChooseSubPayment: 'IBON',
                                    })
      when registration.payment_method['atm']
        send_request_to_allpay(registration, 'ATM')
      else
        render json: 'ERROR!!'
    end
  end

  def paypal

    #render json: Paypal::Express::Request.new(PAYPAL_CONFIG)
    paypal_response = Paypal::Express::Request.new(PAYPAL_CONFIG).setup(
        Paypal::Payment::Request.new(
            currency_code: Locale.find(@registration.locale_id).currency_code,
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

    redirect_to paypal_response.redirect_uri
  end

  def webatm
    send_request_to_allpay(@registration, 'WebATM', {
                                          OrderResultURL: return_registration_url(@registration)
                                      })
  end

  def webatm_resume
    registration_payment = duplicate_registration_payment(params[:id])

    # Resend a order payment to AllPay
    send_request_to_allpay(registration_payment.registration, 'WebATM', {
                                                       OrderResultURL: return_registration_url(registration_payment.registration)
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
  end

  def alipay_resume
    registration_payment = duplicate_registration_payment(params[:id])

    # Resend a order payment to AllPay
    send_request_to_allpay(registration_payment.registration, 'Alipay', {
                                                       AlipayItemName: "#{t('course.name')}: #{registration.course.course_translates.find_by_locale_id(registration.locale_id).name}, #{t('registration.attendance')}: #{registration.attendance}",
                                                       AlipayItemCounts: '1',
                                                       AlipayItemPrice: "#{registration_payment.amount.to_i}",
                                                       Email: registration_payment.registration.email,
                                                       PhoneNo: registration_payment.registration.phone,
                                                       UserName: registration_payment.registration.name
                                                   })
  end

  private

  # Complete register here to prevent that is the registration but no registration_payment
  def set_registration
    @registration = Course.includes(:course_translate)
                          .where(course_translates: {locale_id: registration_params[:locale_id]}, id: registration_params[:course_id])
                          .first
                          .registrations.build(registration_params)

    # Getting total tuition and store it as registration's amount
    @registration.subtotal = @registration.tuition
    @registration.checkout = true
    @registration.checkout_time = Time.now

    @registration.save!
  end

  def set_breadcrumb
    add_breadcrumb t('home'), :root_path
    add_breadcrumb I18n.t('register')
    add_breadcrumb I18n.t('check_out')
  end

  def registration_params
    params.require(:registration).permit(:attendance, :email, :name, :phone, :course_id, :course_option_id, :locale_id,
                                         :payment_method, registration_options_attributes: [:id, :course_option_id])
  end

  def send_request_to_allpay(registration, payment, options = nil)
    @form_data = {
        MerchantID: AllPay.merchant_id,
        MerchantTradeNo: "R#{registration.id}",
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
    registration.create_registration_payment(
        {
            amount: registration.subtotal
        })

    render template: 'order_payment/all_pay_form'
  end

  def duplicate_registration_payment(id)
    # We need to resend the order again but the previous MerchantTradeNo has exists
    # So duplicate the entry then send it to AllPay.
    registration_payment = RegistrationPayment.find(id)

    registration = registration_payment.registration.dup
    registration.save!

    # Set order_products to newest one
    registration_payment.registration.registration_options.each do |option|
      option.update_column(:registration_id, registration.id)
    end

    registration_payment.registration.destroy
    registration_payment.registration_id = registration.id
    registration_payment.save!

    registration_payment
  end
end
