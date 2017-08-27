class UserGiftPaymentCallbackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def remittance

  end

  def allpay_complete

    # RtnCode's value 1 means the transaction was success.
    # In this method, just like the other callback handlers, updating the user_gift payment status.
    if params['RtnCode'] == '1' || params['RtnCode'] == '3'
      user_gift_payment = UserGiftPayment.find_by_user_gift_id!(params['MerchantTradeNo'].delete('G').split('t')[0])

      user_gift_payment.trade_no = params['TradeNo']
      user_gift_payment.trade_time = params['TradeDate']
      user_gift_payment.payment_time = params['PaymentDate']
      user_gift_payment.completed =  true
      user_gift_payment.completed_time = Time.now
      user_gift_payment.save!

      UserGiftMailer.completed_confirmation(user_gift_payment.user_gift_id).deliver_later

      render text: '1|OK'
    else

      # Return the result to allpay server
      render text: '0|Failed! Transaction was interrupted and not completed when AllPay handling the payment.'
    end
  end

  def paypal
    user_gift_payment = UserGiftPayment.find_by_token!(params[:token])

    paypal_response = Paypal::Express::Request.new(PAYPAL_CONFIG).checkout!(
        user_gift_payment.token,
        params[:PayerID],
        Paypal::Payment::Request.new(
            currency_code: Locale.find(user_gift_payment.user_gift.locale_id).currency,
            description: @website_title,
            quantity: 1,
            amount: user_gift_payment.amount
        )
    )

    user_gift_payment.trade_no = paypal_response.payment_info.first.transaction_id
    user_gift_payment.payment_time = paypal_response.timestamp
    user_gift_payment.payer_id = params[:PayerID]
    user_gift_payment.completed = true
    user_gift_payment.completed_time = Time.now
    user_gift_payment.save!

    flash[:icon] = 'fa-smile-o'
    flash[:status] = 'success'
    flash[:message] = t('payment_completed')

    UserGiftMailer.completed_confirmation(user_gift_payment.user_gift_id).deliver_later

    redirect_to user_gift_path(user_gift_payment.user_gift)
  end
end