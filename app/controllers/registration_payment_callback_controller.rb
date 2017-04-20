class RegistrationPaymentCallbackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def remittance

  end

  # Allpay offline trade complete post back
  def allpay_complete

    # RtnCode's value 1 means the transaction was success.
    # In this method, just like the other callback handlers, updating the order payment status.
    if params['RtnCode'] == '1' || params['RtnCode'] == '3'
      registration_payment = RegistrationPayment.find_by_registration_id!(params['MerchantTradeNo'].delete('R').split('t')[0])

      registration_payment.trade_no = params['TradeNo']
      registration_payment.trade_time = params['TradeDate']
      registration_payment.payment_time = params['PaymentDate']
      registration_payment.completed =  true
      registration_payment.completed_time = Time.now
      registration_payment.save!

      RegistrationMailer.completed_confirmation(registration_payment.registration_id).deliver_later

      render text: '1|OK'
    else

      # Return the result to allpay server
      render text: '0|Failed! Transaction was interrupted and not completed when AllPay handling the payment.'
    end
  end

  # Paypal trade complete
  def paypal
    registration_payment = RegistrationPayment.find_by_token!(params[:token])

    paypal_response = Paypal::Express::Request.new(PAYPAL_CONFIG).checkout!(
        registration_payment.token,
        params[:PayerID],
        Paypal::Payment::Request.new(
            currency_code: Locale.find(registration_payment.registration.locale_id).currency,
            description: @website_title,
            quantity: 1,
            amount: registration_payment.amount
        )
    )

    registration_payment.trade_no = paypal_response.payment_info.first.transaction_id
    registration_payment.payment_time = paypal_response.timestamp
    registration_payment.payer_id = params[:PayerID]
    registration_payment.completed = true
    registration_payment.completed_time = Time.now
    registration_payment.save!

    flash[:icon] = 'fa-smile-o'
    flash[:status] = 'success'
    flash[:message] = t('payment_completed')

    RegistrationMailer.completed_confirmation(registration_payment.registration).deliver_later

    redirect_to registration_path(registration_payment.registration)
  end
end
