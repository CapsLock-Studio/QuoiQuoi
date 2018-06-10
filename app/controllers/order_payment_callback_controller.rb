class OrderPaymentCallbackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def remittance

  end

  def allpay_complete

    # RtnCode's value 1 means the transaction was success.
    # In this method, just like the other callback handlers, updating the order payment status.
    if params['RtnCode'] == '1' || params['RtnCode'] == '3'
      order_payment = OrderPayment.find_by_order_id!(params['MerchantTradeNo'].delete('O').split('t')[0])

      order_payment.trade_no = params['TradeNo']
      order_payment.trade_time = params['TradeDate']
      order_payment.payment_time = params['PaymentDate']
      order_payment.completed =  true
      order_payment.completed_time = Time.now
      order_payment.save!

      OrderMailer.completed_confirmation(order_payment.order_id).deliver_later

      render text: '1|OK'
    else

      # Return the result to allpay server
      render text: '0|Failed! Transaction was interrupted and not completed when AllPay handling the payment.'
    end
  end

  def paypal
    order_payment = OrderPayment.find_by_token!(params[:token])

    paypal_response = Paypal::Express::Request.new(PAYPAL_CONFIG).checkout!(
        order_payment.token,
        params[:PayerID],
        Paypal::Payment::Request.new(
            currency_code: Locale.find(order_payment.order.locale_id).currency,
            description: @website_title,
            quantity: 1,
            amount: order_payment.amount
        )
    )

    order_payment.trade_no = paypal_response.payment_info.first.transaction_id
    order_payment.payment_time = paypal_response.timestamp
    order_payment.payer_id = params[:PayerID]
    order_payment.completed = true
    order_payment.completed_time = Time.now
    order_payment.save!

    flash[:icon] = 'fa-smile-o'
    flash[:status] = 'success'
    flash[:message] = t('payment_completed')

    OrderMailer.completed_confirmation(order_payment.order_id).deliver_later

    redirect_to order_path(order_payment.order)
  end

  def stripe
    order = Order.find_by_id(params[:order_id])

    order_payment = order.order_payment

    amount = order_payment.amount.to_i * 100

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => amount,
      :description => @website_title,
      :currency    => 'usd'
    )

    order_payment.trade_no = charge.id
    order_payment.trade_time = Time.now
    order_payment.payment_time = Time.now

    if charge.status == 'succeeded'
      flash[:icon] = 'fa-smile-o'
      flash[:status] = 'success'
      flash[:message] = t('payment_completed')

      order_payment.completed =  true
      order_payment.completed_time = Time.now
    else
      flash[:icon] = 'fa-exclamation-triangle'
      flash[:status] = 'danger'
      flash[:message] = "🚫 #{t('payment_failed')}"
    end

    order_payment.save!

    redirect_to order_path(order)

  rescue Exception => e
    flash[:icon] = 'fa-exclamation-triangle'
    flash[:status] = 'danger'
    flash[:message] = "🚫 #{t('payment_failed')}"

    render template: 'order_payment/stripe'
  end

  def alipay
    order = Order.find(params[:order_id])

    order_payment = order.order_payment

    amount = order_payment.amount.to_i * 100
    charge = Stripe::Charge.create(
      :amount      => amount,
      :currency    => 'usd',
      :source      => params[:source],
    )

    order_payment.trade_no = charge.id
    order_payment.trade_time = Time.now
    order_payment.payment_time = Time.now

    if charge.status == 'succeeded'
      flash[:icon] = 'fa-smile-o'
      flash[:status] = 'success'
      flash[:message] = t('payment_completed')

      order_payment.completed =  true
      order_payment.completed_time = Time.now
    else
      flash[:icon] = 'fa-exclamation-triangle'
      flash[:status] = 'danger'
      flash[:message] = "🚫 #{t('payment_failed')}"
    end

    order_payment.save!

    redirect_to order_path(order)

  rescue Exception => e
    flash[:icon] = 'fa-exclamation-triangle'
    flash[:status] = 'danger'
    flash[:message] = "🚫 #{t('payment_failed')}"

    redirect_to order_path(order)
  end
end