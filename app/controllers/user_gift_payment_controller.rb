class UserGiftPaymentController < ApplicationController
  before_action :set_user_gift, except: [:resume, :webatm_resume, :credit_card_resume, :alipay_resume]
  before_action :check_payment_is_completed, only: [:resume, :webatm_resume, :credit_card_resume, :alipay_resume]
  before_action :authenticate_or_no
  before_action :set_breadcrumb

  def remittance
    flash[:icon] = 'fa-smile-o'
    flash[:message] = t('order_complete_hint')
    flash[:status] = 'success'

    gift = Gift.includes(:gift_translate)
               .where(id: @user_gift.gift_id, gift_translates: { locale_id: @user_gift.locale_id })
               .first

    @user_gift.create_user_gift_payment(
        {
            amount: @user_gift.quantity * gift.gift_translate.quota.to_f,
            expire_time: (Time.now + 4.days).end_of_day
        })

    # Send email to remind customer take the payment
    UserGiftMailer.remind_to_pay(@user_gift.id, t('mailer.subject.payment.remittance')).deliver_later

    redirect_to user_gift_path(@user_gift)
  end

  def cvs_ibon
    send_request_to_allpay(@user_gift, 'CVS', {
        ChooseSubPayment: 'IBON',
    })
  end

  def cvs_family
    send_request_to_allpay(@user_gift, 'CVS', {
        ChooseSubPayment: 'FAMILY',
    })
  end

  def resume
    user_gift = UserGift.find(params[:id])

    case user_gift.payment_method
      when user_gift.payment_method['cvs_family']
        if user_gift.user_gift_payment.payment_no.nil?
          send_request_to_allpay(user_gift, 'CVS', {
              ChooseSubPayment: 'FAMILY',
          })
        else
          render json: 'ERROR!!'
        end
      when user_gift.payment_method['cvs_ibon']
        if user_gift.user_gift_payment.payment_no.nil?
          send_request_to_allpay(user_gift, 'CVS', {
              ChooseSubPayment: 'IBON',
          })
        else
          render json: 'ERROR!!'
        end
      when user_gift.payment_method['atm']
        if user_gift.user_gift_payment.account.nil? || user_gift.user_gift_payment.account.nil?
          send_request_to_allpay(user_gift, 'ATM')
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
            currency_code: Locale.find(@user_gift.locale_id).currency,
            description: @website_title,
            quantity: 1,
            amount: @user_gift.subtotal
        ),
        url_for(controller: :user_gift_payment_callback, action: :paypal),
        cancel_user_gift_url(@user_gift),
        pay_on_paypal: true,
        no_shipping: true
    )

    @user_gift.create_user_gift_payment(
        {
            redirect_uri: paypal_response.redirect_uri,
            token: paypal_response.token,
            amount: @user_gift.subtotal,
            trade_time: paypal_response.timestamp
        })

    # Send email to customer at tomorrow midnight if his/her payment is not completed
    OnlinePaymentRemindJob.set(wait_until: Date.tomorrow.midnight).perform_later(@user_gift.user_gift_payment)

    redirect_to paypal_response.redirect_uri
  end

  def credit_card
    send_request_to_allpay(@user_gift, 'Credit', {
        OrderResultURL: return_user_gift_url(@user_gift)
    })

    # Send email to customer at tomorrow midnight if his/her payment is not completed
    OnlinePaymentRemindJob.set(wait_until: Date.tomorrow.midnight).perform_later(@user_gift.user_gift_payment)
  end

  def credit_card_resume
    user_gift = UserGift.find(params[:id])

    # Resend a order payment to AllPay
    send_request_to_allpay(user_gift, 'Credit', {
        OrderResultURL: return_user_gift_url(user_gift)
    })
  end

  def webatm
    send_request_to_allpay(@user_gift, 'WebATM', {
        OrderResultURL: return_user_gift_url(@user_gift)
    })

    # Send email to customer at tomorrow midnight if his/her payment is not completed
    OnlinePaymentRemindJob.set(wait_until: Date.tomorrow.midnight).perform_later(@user_gift.user_gift_payment)
  end

  def webatm_resume
    user_gift = UserGift.find(params[:id])

    # Resend a order payment to AllPay
    send_request_to_allpay(user_gift, 'WebATM', {
        OrderResultURL: return_user_gift_url(user_gift)
    })
  end

  def atm
    send_request_to_allpay(@user_gift, 'ATM')
  end

  def alipay
    send_request_to_allpay(@user_gift, 'Alipay', {
        AlipayItemName: "#{t('gift')}: #{user_gift.gift.gift_translates.find_by_locale_id(user_gift.locale_id).quota} x #{user_gift.quantity}",
        AlipayItemCounts: '1',
        AlipayItemPrice: "#{@user_gift.subtotal.to_i}",
        Email: @user_gift.email,
        PhoneNo: @user_gift.phone,
        UserName: @user_gift
    })

    # Send email to customer at tomorrow midnight if his/her payment is not completed
    OnlinePaymentRemindJob.set(wait_until: Date.tomorrow.midnight).perform_later(@user_gift.user_gift_payment)
  end

  def alipay_resume
    user_gift = UserGift.find(params[:id])

    # # Resend a order payment to AllPay
    send_request_to_allpay(user_gift, 'Alipay', {
        AlipayItemName: "#{t('gift')}: #{user_gift.gift.gift_translates.find_by_locale_id(user_gift.locale_id).quota} x #{user_gift.quantity}",
        AlipayItemCounts: '1',
        AlipayItemPrice: "#{user_gift.subtotal.to_i}",
        Email: user_gift.email,
        PhoneNo: user_gift.phone,
        UserName: user_gift
    })
  end

  private

  def set_user_gift
    @user_gift = UserGift.new(user_gift_params)

    unless current_user.nil?
      @user_gift.user_id = current_user.id
    end

    @user_gift.checkout = true
    @user_gift.checkout_time = Time.now

    @user_gift.save!
  end

  def set_breadcrumb
    add_breadcrumb t('home'), :root_path
    add_breadcrumb I18n.t('register')
    add_breadcrumb I18n.t('check_out')
  end

  def user_gift_params
    user_gift_info = params.require(:user_gift)

    if user_gift_info.is_a? String
      recombined_raw_params = user_gift_info.split('&').map do |raw_data|
        pair_data = raw_data.split('=')
        "user_gift%5B#{pair_data[0]}%5D=#{pair_data[1]}"
      end.join('&')

      raw_params = Rack::Utils.parse_nested_query recombined_raw_params

      user_gift_info = ActionController::Parameters.new(raw_params).require(:user_gift)
    end

    user_gift_info.permit(:gift_id, :quantity, :locale_id, :payment_method)
  end

  def send_request_to_allpay(user_gift, payment, options = nil)
    gift_translate = GiftTranslate.where(gift_id: user_gift.gift_id, locale: user_gift.locale_id)
                .first

    @form_data = {
        MerchantID: AllPay.merchant_id,
        MerchantTradeNo: "G#{user_gift.id}t#{Time.now.to_i}",
        MerchantTradeDate: user_gift.checkout_time.strftime('%Y/%m/%d %H:%I:%S'),
        PaymentType: 'aio',
        TotalAmount: user_gift.quantity * gift_translate.quota.to_i,
        TradeDesc: @website_title,
        ItemName: "#{t('gift')}: #{gift_translate.quota} x #{user_gift.quantity}",
        ReturnURL: url_for(controller: :user_gift_payment_callback, action: :allpay_complete),
        ChoosePayment: payment,
        ClientRedirectURL: user_gift_url(user_gift),
    }

    unless options.nil?
      @form_data = @form_data.merge(options)
    end

    # render json: @form_data

    # Record payment information
    if user_gift.user_gift_payment.nil?
      user_gift.create_user_gift_payment(
          {
              amount: user_gift.quantity * gift_translate.quota,
          })
    end

    render template: 'order_payment/all_pay_form'
  end

  def check_payment_is_completed
    # Check if the payment is completed or not, stop resume payment action.
    user_gift = UserGift.find(params[:id])
    if user_gift.user_gift_payment.completed?
      flash[:icon] = 'fa-lightbulb-o'
      flash[:status] = 'success'
      flash[:message] = t('payment_already_completed')

      redirect_to user_gift_path(user_gift)
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