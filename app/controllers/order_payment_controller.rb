class OrderPaymentController < ApplicationController
  before_action :checkout, except: [:resume, :webatm_resume, :credit_card_resume, :alipay_resume]
  before_action :check_payment_is_completed, only: [:resume, :alipay_resume, :credit_card_resume, :webatm_resume]
  before_action :set_breadcrumb

  def remittance
    flash[:icon] = 'fa-smile-o'
    flash[:message] = t('order_complete_hint')
    flash[:status] = 'success'

    @order.create_order_payment(
        {
            amount: @order.subtotal,
            expire_time: (Time.now + 4.days).end_of_day
        })

    # Send email to remind customer take the payment
    OrderMailer.remind_to_pay(@order.id, t('mailer.subject.payment.remittance')).deliver_later

    redirect_to order_path(@order)
  end

  def cvs_ibon
    send_request_to_allpay(@order, 'CVS', {
                                          ChooseSubPayment: 'IBON',
                                      })
  end

  def cvs_family
    send_request_to_allpay(@order, 'CVS', {
                                          ChooseSubPayment: 'FAMILY',
                                      })
  end

  def resume
    order = Order.find(params[:id])

    case order.payment_method
      when order.payment_method['cvs_family']
        if order.order_payment.payment_no.nil?
          send_request_to_allpay(order, 'CVS', {
                                          ChooseSubPayment: 'FAMILY',
                                      })
        else
          render json: 'ERROR!!'
        end
      when order.payment_method['cvs_ibon']
        if order.order_payment.payment_no.nil?
          send_request_to_allpay(order, 'CVS', {
                                          ChooseSubPayment: 'IBON',
                                      })
        else
          render json: 'ERROR!!'
        end
      when order.payment_method['atm']
        if order.order_payment.bankcode.nil? || order.order_payment.account.nil?
          send_request_to_allpay(order, 'ATM')
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
            currency_code: Locale.find(@order.locale_id).currency,
            description: @website_title,
            quantity: 1,
            amount: @order.subtotal
        ),
        url_for(controller: :order_payment_callback, action: :paypal),
        cancel_order_url(@order),
        pay_on_paypal: true,
        no_shipping: true
    )

    @order.create_order_payment(
        {
            redirect_uri: paypal_response.redirect_uri,
            token: paypal_response.token,
            amount: @order.subtotal,
            trade_time: paypal_response.timestamp
        })

    # Send email to customer at tomorrow midnight if his/her payment is not completed
    OnlinePaymentRemindJob.set(wait_until: Date.tomorrow.midnight).perform_later(@order.order_payment)

    redirect_to paypal_response.redirect_uri
  end

  def credit_card
    send_request_to_allpay(@order, 'Credit', {
                                          OrderResultURL: return_order_url(@order)
                                      })

    # Send email to customer at tomorrow midnight if his/her payment is not completed
    OnlinePaymentRemindJob.set(wait_until: Date.tomorrow.midnight).perform_later(@order.order_payment)
  end

  def credit_card_resume
    order = Order.find(params[:id])

    # Resend a order payment to AllPay
    send_request_to_allpay(order, 'Credit', {
                                    OrderResultURL: return_order_url(order)
                                })
  end

  def webatm
    send_request_to_allpay(@order, 'WebATM', {
                                          OrderResultURL: return_order_url(@order)
                                      })

    # Send email to customer at tomorrow midnight if his/her payment is not completed
    OnlinePaymentRemindJob.set(wait_until: Date.tomorrow.midnight).perform_later(@order.order_payment)
  end

  def webatm_resume
    order = Order.find(params[:id])

    # Resend a order payment to AllPay
    send_request_to_allpay(order, 'WebATM', {
                                    OrderResultURL: return_order_url(order)
                                })
  end

  def atm
    send_request_to_allpay(@order, 'ATM')
  end

  def alipay
    item_names = @order.order_products.map{|order_products| "#{order_products.product.product_translates.find_by_locale_id(@order.locale_id).name}" }
    item_counts = @order.order_products.map{|order_products| "#{order_products.quantity}" }
    item_prices = @order.order_products.map{|order_products| "#{order_products.price.to_i}" }

    if @order.shipping_fee! > 0
      item_names << "#{t('shipping_fee')}"
      item_counts << "1"
      item_prices << "#{@order.shipping_fee!.to_i}"
    end

    send_request_to_allpay(@order, 'Alipay', {
                                    AlipayItemName: item_names.join('#'),
                                    AlipayItemCounts: item_counts.join('#'),
                                    AlipayItemPrice: item_prices.join('#'),
                                    Email: @order.user.email,
                                    PhoneNo: @order.phone,
                                    UserName: @order.name
                                      })

    # Send email to customer at tomorrow midnight if his/her payment is not completed
    OnlinePaymentRemindJob.set(wait_until: Date.tomorrow.midnight).perform_later(@order.order_payment)
  end

  def alipay_resume
    order = Order.find(params[:id])

    item_names = order.order_products.map{|order_products| "#{order_products.product.product_translates.find_by_locale_id(order.locale_id).name}" }
    item_counts = order.order_products.map{|order_products| "#{order_products.quantity}" }
    item_prices = order.order_products.map{|order_products| "#{order_products.price.to_i}" }

    if order.shipping_fee! > 0
      item_names << "#{t('shipping_fee')}"
      item_counts << "1"
      item_prices << "#{order.shipping_fee!.to_i}"
    end

    # Resend a order payment to AllPay
    send_request_to_allpay(order, 'Alipay', {
                                                       AlipayItemName: item_names.join('#'),
                                                       AlipayItemCounts: item_counts.join('#'),
                                                       AlipayItemPrice: item_prices.join('#'),
                                                       Email: order.user.email,
                                                       PhoneNo: order.phone,
                                                       UserName: order.name
                                                   })
  end

  def free
    # Record payment information
    if @order.order_payment.nil? && @order.subtotal == 0
      order_payment = @order.build_order_payment
      order_payment.amount = @order.subtotal
      order_payment.payment_time = Time.now
      order_payment.completed =  true
      order_payment.completed_time = Time.now
      order_payment.save!

      OrderMailer.completed_confirmation(order_payment.order_id).deliver_later

      flash.now[:icon] = 'fa-smile-o'
      flash.now[:status] = 'success'
      flash.now[:message] = t('payment_completed')

      redirect_to order_path(@order.id)
    end
  end

  private
  def checkout
    @order = @order_in_cart

    @order_in_cart.checkout = true
    @order_in_cart.checkout_time = Time.now

    @order_in_cart.save!
  end

  def set_breadcrumb
    add_breadcrumb t('home'), :root_path
    add_breadcrumb I18n.t('cart'), :cart_path
    add_breadcrumb I18n.t('check_out')
  end

  def send_request_to_allpay(order, payment, options = nil)
    if order.locale_id == Locale.where(lang: 'en').first.id
      order.subtotal = order.get_ntd_subtotal
      order.save
    end
    @form_data = {
        MerchantID: AllPay.merchant_id,
        MerchantTradeNo: "O#{order.id}t#{Time.now.to_i}",
        MerchantTradeDate: order.checkout_time.strftime('%Y/%m/%d %H:%I:%S'),
        PaymentType: 'aio',
        TotalAmount: order.subtotal.to_i,
        TradeDesc: @website_title,
        ItemName: order.order_products.map{|order_products|
          "#{order_products.product.product_translates.find_by_locale_id(order.locale_id).name} x #{order_products.quantity}"
        }.join('#'),
        ReturnURL: url_for(controller: :order_payment_callback, action: :allpay_complete),
        ChoosePayment: payment,
        ClientRedirectURL: order_url(order),
    }

    unless options.nil?
      @form_data = @form_data.merge(options)
    end

    # render json: @form_data

    # Record payment information
    if order.order_payment.nil?
      order.create_order_payment(
          {
              amount: order.subtotal
          })
    end

    render template: 'order_payment/all_pay_form'
  end

  def check_payment_is_completed
    # Check if the payment is completed or not, stop resume payment action.
    order = Order.find(params[:id])
    if order.order_payment.completed?
      flash[:icon] = 'fa-lightbulb-o'
      flash[:status] = 'success'
      flash[:message] = t('payment_already_completed')

      redirect_to order_path(order)
    end
  end
end
